#!/usr/bin/env python3
"""Render a public Gemini share URL and print extracted visible text.

This helper is intentionally narrow. It only accepts Gemini public share URLs
and writes no output files. The caller should summarize/redact the text before
creating an input note.
"""

from __future__ import annotations

import argparse
import html
import os
import pty
import re
import shutil
import select
import signal
import subprocess
import sys
import tempfile
import time
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlparse


DEFAULT_CHROME_PATHS = (
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
)


class VisibleTextParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self._skip_depth = 0
        self._chunks: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag in {"script", "style", "template", "noscript", "svg"}:
            self._skip_depth += 1
        if tag in {"p", "div", "li", "tr", "h1", "h2", "h3", "h4", "br"}:
            self._chunks.append("\n")

    def handle_endtag(self, tag: str) -> None:
        if tag in {"script", "style", "template", "noscript", "svg"}:
            self._skip_depth = max(0, self._skip_depth - 1)
        if tag in {"p", "div", "li", "tr", "h1", "h2", "h3", "h4"}:
            self._chunks.append("\n")

    def handle_data(self, data: str) -> None:
        if self._skip_depth:
            return
        text = data.strip()
        if text:
            self._chunks.append(text)

    def text(self) -> str:
        text = html.unescape(" ".join(self._chunks))
        text = re.sub(r"[ \t\r\f\v]+", " ", text)
        text = re.sub(r"\n\s+", "\n", text)
        text = re.sub(r"\n{3,}", "\n\n", text)
        return "\n".join(dedupe_lines(text.splitlines())).strip()


def dedupe_lines(lines: list[str]) -> list[str]:
    result: list[str] = []
    last = ""
    for line in lines:
        line = line.strip()
        if not line or line == last:
            continue
        if is_boilerplate(line):
            continue
        result.append(line)
        last = line
    return result


def is_boilerplate(line: str) -> bool:
    lowered = line.lower()
    boilerplate = {
        "sign in",
        "google privacy policy",
        "google terms of service",
        "opens in a new window",
        "your privacy & gemini apps",
    }
    if lowered in boilerplate:
        return True
    if lowered.startswith("gemini may display inaccurate info"):
        return True
    return False


def validate_url(url: str) -> None:
    parsed = urlparse(url)
    if parsed.scheme != "https":
        raise SystemExit("ERROR: URL must use https.")
    if parsed.netloc != "gemini.google.com":
        raise SystemExit("ERROR: URL host must be gemini.google.com.")
    if not parsed.path.startswith("/share/"):
        raise SystemExit("ERROR: URL path must start with /share/.")


def find_chrome() -> str:
    env_path = os.environ.get("CHROME_PATH")
    if env_path and Path(env_path).exists():
        return env_path
    for path in DEFAULT_CHROME_PATHS:
        if Path(path).exists():
            return path
    for binary in ("google-chrome", "chromium", "chromium-browser", "msedge"):
        found = shutil.which(binary)
        if found:
            return found
    raise SystemExit("ERROR: Could not find Chrome, Chromium, or Edge.")


def render_dom(url: str, chrome_path: str, timeout: int) -> str:
    with tempfile.TemporaryDirectory(prefix="capture-input-note-chrome-") as profile:
        command = [
            chrome_path,
            "--headless=new",
            "--disable-gpu",
            "--disable-background-networking",
            "--disable-component-update",
            "--disable-sync",
            "--metrics-recording-only",
            "--no-first-run",
            f"--user-data-dir={profile}",
            "--timeout=15000",
            "--dump-dom",
            url,
        ]
        return run_with_pty(command, timeout)


def run_with_pty(command: list[str], timeout: int) -> str:
    master_fd, slave_fd = pty.openpty()
    output = bytearray()
    proc = subprocess.Popen(
        command,
        stdin=subprocess.DEVNULL,
        stdout=slave_fd,
        stderr=slave_fd,
        close_fds=True,
        start_new_session=True,
    )
    os.close(slave_fd)

    deadline = time.monotonic() + timeout
    seen_html_at: float | None = None
    try:
        while time.monotonic() < deadline:
            ready, _, _ = select.select([master_fd], [], [], 0.25)
            if ready:
                try:
                    chunk = os.read(master_fd, 65536)
                except OSError:
                    break
                if not chunk:
                    break
                output.extend(chunk)
                if b"</html>" in output and seen_html_at is None:
                    seen_html_at = time.monotonic()
            if seen_html_at is not None and time.monotonic() - seen_html_at > 1.0:
                break
            if proc.poll() is not None:
                break
    finally:
        if proc.poll() is None:
            try:
                os.killpg(proc.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
            try:
                proc.wait(timeout=3)
            except subprocess.TimeoutExpired:
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
        os.close(master_fd)

    text = output.decode("utf-8", errors="replace")
    start = text.find("<!DOCTYPE")
    if start == -1:
        start = text.find("<html")
    if start != -1:
        text = text[start:]
    end = text.rfind("</html>")
    if end != -1:
        text = text[: end + len("</html>")]
    if not text:
        raise SystemExit("ERROR: Chrome timed out before producing DOM output.")
    return text


def extract_text(dom: str) -> str:
    parser = VisibleTextParser()
    parser.feed(dom)
    text = parser.text()
    marker = "Shared conversation"
    if marker in text:
        text = text[text.index(marker) :]
    return text


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("url")
    parser.add_argument("--timeout", type=int, default=30)
    args = parser.parse_args()

    validate_url(args.url)
    chrome_path = find_chrome()
    dom = render_dom(args.url, chrome_path, args.timeout)
    text = extract_text(dom)
    if not text:
        print("ERROR: No visible text extracted.", file=sys.stderr)
        return 2
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

# Hook: ensure-vercel-cli

Status: active
Version: 0.1.0

## What it does

This hook runs before every Bash tool call. It checks whether the Vercel CLI is
present at the managed tools location
(`~/.local/share/ai-toolkit/tools/node_modules/.bin/vercel`). If the binary is
missing, it installs Vercel CLI via npm into that directory and creates a symlink
at `~/.local/bin/vercel` so the CLI is available on PATH.

The hook is intentionally lightweight: the existence check is a single `[ -f ]`
test, so it adds near-zero overhead on subsequent tool calls once the binary is
in place.

## When to use it

Apply this hook to any project that relies on Vercel deployments and may need to
call `vercel logs`, `vercel inspect`, or `vercel env ls` during an AI coding
session. It pairs well with the `vercel-operations` baseline pack.

## What it installs

| Location | Purpose |
|---|---|
| `~/.local/share/ai-toolkit/tools/node_modules/.bin/vercel` | Managed npm install of the Vercel CLI |
| `~/.local/bin/vercel` | Symlink so `vercel` is on PATH |

npm is expected to be available in the environment. The install uses
`npm install --prefix ... vercel --silent` and does not require global npm
permissions.

## Windows support

The current adapter (`adapters/claude.json.block`) embeds a bash command and
works on macOS and Linux only. A PowerShell-based command for Windows is planned
for a future version.

## Identification marker

Every hook entry written by this pack contains the comment
`# ai-toolkit-hook:ensure-vercel-cli` near the start of its command string. The
`hooks` CLI uses this marker to identify and manage the entry during `apply`,
`remove`, and `verify` operations.

# Layered Ownership Baseline

Status: active
Version: 0.1.0

This is a tool-neutral always-on baseline for AI agents working inside a
multi-repo personal system. It keeps decision records where they belong and
prevents any single repo from drifting into a central governance hub.

## Principles

1. Each layer records its own decisions.
   A repo's roadmap, status entries, and decision records cover only the
   assets that repo owns. Another layer's merge plans, status changes, or
   boundaries are recorded in that layer's own documents.

2. Cross-layer references are pointers, not ownership.
   When another layer's state matters, link to the owning repo's artifact
   ("governs itself in X") instead of duplicating or governing it.

3. Identify the owner before writing.
   Before recording a status or decision entry, ask which layer owns the
   affected asset, and write the entry there — even when the current session
   happens to be in a different repo.

4. No central governance hub.
   If a document starts mirroring another repo's changes, that is the
   hub pattern re-forming: stop, move the content to its owner, and leave a
   pointer behind.

## Origin

Authored 2026-07-03 after a real violation: capture-layer merge decisions
were written into `ai-toolkit`'s roadmap, silently recreating the
governance-hub pattern the operator had frozen out of
`ai-ops-ecosystem-spec` the day before. The operator's boundary is explicit:
the second-brain system must never be mixed with the skills and specs
layers.

## Managed Block

The pack applies one managed block per instruction file through the standard
baseline CLI. The block can be updated or removed without rewriting
surrounding repo-specific instructions.

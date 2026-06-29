# Code-Doc Sync Baseline

Status: active
Version: 0.1.0

Always-on documentation hygiene for AI coding agents working in repositories
that contain architecture documentation, flow diagrams, or developer references
alongside the code.

Distilled from two production bug fixes that were merged without updating
adjacent flow trees and architecture docs, and from a flow tree that described
an abstract declaration site instead of the concrete runtime type.

## Principles

1. Scan for adjacent documentation before closing a behavior-changing task.
   Before marking any task complete that changes a public API, method signature,
   class relationship, or runtime control flow: scan the repository for adjacent
   architecture docs, flow trees, developer references, or progress logs that
   describe the changed behavior. Read each candidate and decide whether it needs
   updating. An explicit decision of "no update needed" is fine; skipping the
   scan is not. This applies equally to bug fixes and feature work — bugs often
   correct behavior that was documented as if it were correct.

2. Show the concrete runtime type in flow diagrams and call traces.
   When writing or updating a flow tree, sequence diagram, or call trace that
   involves a virtual or abstract method, use the concrete class name that
   actually executes at runtime — not the abstract declaration site. Writing the
   base class name hides the polymorphism the diagram is meant to explain, and
   creates the false impression that the base class logic runs unconditionally.

## Applying in a Repo

These principles are folder-name-agnostic. If the repo's CLAUDE.md or README
specifies where architecture documentation lives, read that first. Otherwise,
look for common patterns: `_Documents/`, `docs/`, `architecture/`, `design/`,
`ADR/`. If no documentation folder is found, these principles fire on nothing —
that is an acceptable outcome.

## Priority

Apply this baseline before ordinary implementation habits, but never use it to
override explicit user instructions, safety rules, privacy boundaries, or
stricter repo-local instructions.

## Non-Goals

- This is not a requirement to write documentation where none exists.
- This does not require every code change to produce a doc change.
- This does not define what documentation format or structure to use.
- Principle 2 does not prohibit noting the abstract declaration — it requires
  the concrete runtime class to be the primary label.

## Origin

Rogers/Fido carrier integration (CarrierIntegrationServer). Two bug-fix commits
(613daf50, 2a7152ea) were merged without reviewing adjacent flow trees or the
architecture progress log. A flow tree also labeled a virtual call as
`BaseRogersCorpService.BuildConfiguration` when the method that executes at
runtime is `FidoCorpService.BuildConfiguration`.

# Code-Doc Sync Baseline

Status: active
Version: 0.2.0

Always-on documentation hygiene for AI coding agents working in repositories
that contain architecture documentation, flow diagrams, or developer references
alongside the code.

Distilled from two production bug fixes that were merged without updating
adjacent flow trees and architecture docs, and from a flow tree that described
an abstract declaration site instead of the concrete runtime type.

## Principles

1. Check adjacent documentation before closing a behavior-changing task.
   First establish whether the repo has architecture docs at all (see "Applying
   in a Repo" below); if no documentation folder exists, this principle fires
   on nothing. When docs exist, and the task changes externally observable
   behavior or a contract other code depends on — a public API, a documented
   flow, a class relationship that appears in diagrams — check the docs that
   describe the changed behavior and decide whether each needs updating. An
   explicit decision of "no update needed" is fine; skipping the check is not.
   This applies equally to bug fixes and feature work — bugs often correct
   behavior that was documented as if it were correct. Purely internal changes
   with no observable-behavior or contract impact do not require the check.

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

This baseline takes precedence over ordinary implementation habits, but never use it to
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

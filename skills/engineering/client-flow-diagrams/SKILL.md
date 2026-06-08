---
name: client-flow-diagrams
description: Create or revise high-level flow diagrams for client or non-technical audiences. Use when the user needs a workflow, process, integration, or system-interaction diagram that communicates business-level behavior without exposing implementation details.
---

# Client Flow Diagrams

Produce diagrams that help non-technical audiences understand a process — not engineers understand a system.

## Trigger

**Use this skill when:**
- Creating or revising a business-level workflow, process, or integration diagram for a client or stakeholder
- Translating technical documentation (ADRs, architecture notes, code flows) into a client-safe diagram
- The audience includes business owners, product managers, client representatives, or non-technical staff
- The diagram needs to show system interactions, decision points, or phase boundaries without code-level detail

**Do not use this skill when:**
- Creating detailed implementation architecture for developers
- Documenting code-level control flow (use a developer-facing ADR instead)
- The user only needs an internal engineering diagram
- A diagram would not improve communication over plain text

## Workflow

### 1 — Clarify before diagramming

Confirm or ask:
- **Audience**: Who will read this? What is their technical background?
- **Purpose**: What decision or understanding should the reader leave with?
- **Scope**: Which systems, phases, and boundaries are in and out of scope?
- **Detail level**: Does the reader need error paths and decision points, or just the happy path?

When source material is technical (ADRs, code, API docs), treat it as confirmed. Treat your own inferences about business meaning as assumptions — flag them and ask when uncertain.

### 2 — Identify actors, systems, and boundaries

Extract from source material:
- **Actors**: Who or what initiates the flow?
- **Systems**: What systems participate? Group them into swimlanes.
- **Phases**: Are there distinct sequential phases? Split into multiple diagrams when a single one exceeds ~8 nodes.
- **Decisions**: What Yes/No branch points affect the outcome?
- **Boundaries**: Where does one system hand off to another?

### 3 — Produce the diagram

Prefer **Mermaid `flowchart TD`** for multi-system decision flows.

Use **swimlane subgraphs** to show which system owns each step:
```
subgraph SystemName["System Label"]
    ...
end
```

Apply **consistent visual differentiation** between node types: at minimum distinguish process steps, decision points, success outcomes, and error outcomes. The specific colour scheme, icons, step numbering, and legend format used in the first session are recorded in `lessons.md` as candidate patterns pending further validation.

**Mermaid routing note:** Mermaid's init `curve` setting applies uniformly to all edges — there is no per-edge routing control. The `step` option adds right-angle turns to every connection including simple vertical ones. Explain this limitation if a user asks for selective right-angle routing.

### 4 — Add explanations below each diagram

Include:
- What each key decision means in plain language
- Important edge cases (e.g. partial failure behaviour)
- A cross-reference to technical documentation for readers who need more depth

### 5 — Review before delivering

See `review-checklist.md`. Key checks:
- No internal class names, method names, or HTTP status codes visible
- No jargon that requires developer context — replace with business language
- No single diagram with more than ~8–10 nodes — split if needed
- Error paths traceable and concisely labelled

## Signs this skill needs revision

- Diagrams regularly require jargon cleanup after delivery
- Clients consistently ask for more or less detail than the workflow produces
- A better Mermaid option becomes available for per-edge routing control

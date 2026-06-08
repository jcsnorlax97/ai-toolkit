# Lessons — client-flow-diagrams

Append one entry per real use. Sanitize: no client names, confidential data,
raw conversations, credentials, or unnecessary project details.

Promote a takeaway into SKILL.md only when:
- it addresses a serious correctness or confidentiality risk; or
- it has been validated across multiple uses; or
- the user explicitly approves the change.

---

## 2026-06-08 — Initial session (first use)

**Task context:**
Translating developer-facing technical architecture documents (class hierarchies,
flow trees, design decisions) into business-level flow diagrams for a
non-technical stakeholder audience.

**Mistakes and weaknesses observed:**

1. **Technical jargon not proactively stripped in first draft.**
   The first diagram draft carried over vocabulary from the source material
   (internal class names, HTTP status codes, method signatures). A revision pass
   was needed after the user pointed them out.
   — *Cause*: Defaulted to source vocabulary without applying a client-safety
   filter first.
   — *Takeaway*: Before writing any node label, ask "would a non-developer
   understand this without context?" Strip class names, method names, and status
   codes by default.
   — *Reusable*: Yes.
   — *Status*: Reflected in Step 5 (review checklist) in SKILL.md. Kept because
   it is a correctness risk for the deliverable, not a stylistic preference.

2. **`step` curve applied globally produced excessive right-angle turns.**
   The `%%{init: {"flowchart": {"curve": "step"}}}%%` directive was added after
   the user asked for right-angle lines. The user then found that simple vertical
   connections also acquired unnecessary horizontal jogs.
   — *Cause*: Mermaid's curve setting applies to all edges uniformly; per-edge
   routing control does not exist. The user's intent was "right angles only at
   branches," not "right angles everywhere."
   — *Takeaway*: Explain the limitation before applying any curve setting. The
   default routing draws straight segments for aligned nodes and only bends where
   the layout needs it.
   — *Reusable*: Yes.
   — *Status*: Reflected in Step 3 of SKILL.md as a factual note about Mermaid's
   routing behaviour (not a prohibition — the tone was softened during the
   lifecycle correction on 2026-06-08).

3. **Lifecycle correction — 2026-06-08.**
   Several first-session stylistic preferences were incorrectly promoted into
   SKILL.md at creation time. They have been moved back to lessons.md pending
   further validation. The preferences were:
   - Specific `classDef` hex colour values for process/decision/success/error/neutral
   - Emoji in swimlane subgraph labels
   - Step numbers (`Step N —`) prefixed to node labels
   - Visual Mermaid legend (standalone small diagram) preferred over a markdown table
   - Document header table (Version, Status, Audience, Related) for formal deliverables
   - Prescriptive output structure ordering (header → overview → legend → diagrams →
     notes → comparison → cross-reference)
   — *Why demoted*: Each was observed and approved in a single session. None
   represents a correctness or confidentiality risk. All are candidate patterns,
   not validated conventions.
   — *Promote when*: validated across multiple uses or explicitly approved.

**Successes observed (confirmed, not yet promoted):**

The following choices were accepted or explicitly approved in the first session.
They are candidate patterns — record further evidence before promoting to SKILL.md.

- **Colour-coded nodes** (blue process / yellow decision / green success / red
  error / grey neutral). Specific classDef values used:
  ```
  classDef process  fill:#CCE5FF,stroke:#0D6EFD,color:#000
  classDef decision fill:#FFF3CD,stroke:#FFC107,color:#000
  classDef success  fill:#D4EDDA,stroke:#198754,color:#000,font-weight:bold
  classDef error    fill:#F8D7DA,stroke:#DC3545,color:#000
  classDef neutral  fill:#E9ECEF,stroke:#6C757D,color:#000
  ```
  User approved without requesting changes. *Observed once.*

- **Step numbers in node labels** (`Step N —` prefix). User described them as
  "explicit & nice." *Observed once.*

- **Visual Mermaid legend** (small standalone diagram showing all node types with
  actual colours). Replacing a markdown colour table was accepted without
  pushback. *Observed once.*

- **Emoji on swimlane headers and outcome nodes** (✅ / ❌). User explicitly
  asked for icons and accepted the placement without revision. *Observed once.*

- **Splitting into two diagrams** when a single flow has distinct sequential
  phases. A two-phase split kept each diagram digestible.
  User did not ask to recombine them. *Observed once.*

- **Document header table** (Version, Status, Audience, Related) for formal
  deliverables. User accepted it as making the document "formal enough."
  *Observed once.*

**Open questions after this session:**
- Should the review checklist be applied silently, or shown to the user for
  sign-off before delivery?
- Is a comparison table (two flows side by side) always useful, or only when the
  user explicitly asks to compare them?

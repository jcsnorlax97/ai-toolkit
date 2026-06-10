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

---

## 2026-06-10 — Second session (draw.io output format)

**Task context:**
Activation business flow diagrams for a client-facing ADR involving two related
brands. Two swimlane diagrams, 4 columns each. The client identified that Mermaid
frames were unequal heights and the frame labels were inside the borders.

**Mistakes and weaknesses observed:**

1. **Mermaid cannot produce equal-height swimlane frames or external frame labels.**
   The user noticed visual inconsistency: Mermaid renders each subgraph just tall
   enough for its content, so columns with fewer nodes are shorter than those with
   more. Frame labels also render inside the border, not above it.
   — *Cause*: Mermaid subgraph layout is fully automatic; no height or label-position
   overrides exist.
   — *Takeaway*: When the deliverable requires precise visual polish (equal column
   heights, labels above borders), generate draw.io XML instead of Mermaid. The user
   opens the file in app.diagrams.net and exports as SVG/PNG.
   — *Reusable*: Yes — this is a hard Mermaid limitation.
   — *Status*: Promoted to SKILL.md Step 3 as the output-format decision rule.

2. **draw.io edge routing: overlapping lines when multiple edges share the same target.**
   First-pass XML produced 5 "No" edges all converging on a single SF_ERR node,
   each using the default orthogonalEdgeStyle with no waypoints. All five rendered
   on top of each other.
   — *Cause*: Without explicit waypoints, draw.io's auto-router assigns no spacing
   between parallel edges going to the same target.
   — *Takeaway*: Each "No" edge needs its own dedicated vertical spine in the
   routing gap (staggered x: 295, 275, 255, 235, 215 — 20 px apart). Add staggered
   entryY values on the target (0.15, 0.25, 0.35, 0.45, 0.55) so arrow-tips don't
   pile on the same point.
   — *Reusable*: Yes — applies whenever 3+ edges converge on one node.
   — *Status*: Candidate pattern pending repeated validation.

3. **draw.io edge routing: auto-router crossed through text-bearing shapes.**
   Without waypoints, the router chose paths that passed through the interior of
   shapes that contained text.
   — *Cause*: Orthogonal auto-routing computes paths at render time and doesn't
   always avoid shapes, especially when multiple edges compete for the same corridor.
   — *Takeaway*: Reserve a wide routing gap (≥100 px) between the leftmost column
   (Storefront) and the logic column (CIS). Route all "No" edges exclusively through
   this gap with explicit waypoints. "Yes" paths exit the diamond bottom straight
   down — no waypoints needed.
   — *Reusable*: Yes.
   — *Status*: Candidate pattern pending repeated validation.

4. **No legend in first draft.**
   The user asked for a legend explaining colour and shape meanings. Without it,
   readers cannot interpret the visual encoding without prior context.
   — *Cause*: Legend was not in the original skill workflow for this format.
   — *Takeaway*: Always include a Legend container when colour-coded shapes are used
   (already required by review-checklist.md, but now also required in the generate
   step, not just the review step).
   — *Reusable*: Yes.
   — *Status*: Kept as a general review rule; exact legend structure remains a
   candidate pattern.

**Successes observed (confirmed, not yet promoted):**

- **draw.io swimlane container style for borderless frames:**
  `swimlane;startSize=0;fillColor=none;strokeColor=#888888;strokeWidth=2;`
  with a separate `text` label cell above the container (y=40, container y=78).
  Accepted without revision. *Observed once.*

- **R1→SF_OK "below-content" routing pattern for long cross-column return edges:**
  When a rightmost-column node must connect back to a leftmost-column node, and
  the gap area is occupied by vertical spines, routing the edge at y = frame_bottom
  + 30 (below all frame content) keeps it from crossing any spine. *Observed once.*

**Open questions after this session:**
- When should the user be recommended to use draw.io vs Mermaid upfront, before
  the layout problem appears? Possible heuristic: ≥3 columns with uneven node
  counts → recommend draw.io proactively.

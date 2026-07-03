# Source Intake - Social Live Photo Card

## Source

- X post: `https://x.com/op7418/status/2072510211626336740`
- X author: `@op7418`, display name `歸藏(guizang.ai)`
- X publication date: 2026-07-02
- Referenced article title: `能帮你做 Live Photo 了！藏师傅社交卡片 Skill 重磅更新`
- Referenced repository: `https://github.com/op7418/guizang-social-card-skill`
- Repository license observed: AGPL-3.0
- Intake date: 2026-07-03

## Access Notes

- Original X URL was opened, but the page did not expose readable post content
  directly.
- Public X oEmbed returned the post author, date, and truncated HTML.
- `api.fxtwitter.com` returned the public post text, quoted X Article blocks,
  and media metadata. Treat this as a third-party renderer, not official X API
  data.
- GitHub repository and README were checked as public source context.

## Adoption Decision

- Primary destination: `Skill`
- Retention: `revisit-on-trigger`
- Confidence: `medium`

The source describes a repeatable workflow with clear triggers, inputs, modes,
quality gates, stop conditions, and delivery checks. It is not suitable as a
portable baseline because the behavior is domain-specific media production, not
an always-on default posture for ordinary agent work.

No upstream files, templates, assets, scripts, or skill text were imported.

## One-By-One Classification

| Source item | Classification | Local action |
| --- | --- | --- |
| Live Photo generation/editing for social cards | Skill | Create `social-live-photo-card` as the containing workflow. |
| Step explanations, product details, animated webpage demos | Use-case examples | Include as suitable material, not separate skills. |
| Single-video dynamic card | Skill mode | Include as one card structure. |
| Two-, three-, or four-panel Live Photo collage | Skill mode | Include as one card structure. |
| Triple Live Photo for parallel results or views | Skill mode | Include with an explicit "parallel, not sequential tutorial" boundary. |
| Long-video screening before selecting a segment | Workflow phase | Include contact-sheet screening before editing. |
| Roughly 10-second prepared clips with one focus | Rule inside skill | Include as material guidance, not a baseline. |
| Product update / AI demo / game / tutorial / travel / food / craft scenes | Examples | Include as suitable material. |
| First frame must work as a static card | Verification gate | Include before motion generation and delivery. |
| Treat video as an image slot with crop and quiet-zone rules | Workflow rule | Include in first-frame and layout checks. |
| Contact sheet for sparse review | Workflow phase | Include for long or unclear videos. |
| Platform duration differences (`3s` WeChat, `5s` Rednote/Xiaohongshu) | Delivery constraint | Include in platform confirmation and verification. |
| Phone-side publish path / `.pvt` package | Delivery constraint | Include as packaging and delivery note; do not promise `.pvt` if tooling is missing. |
| Live Photo fills the gap between static cards and short videos | Rationale | Mention implicitly through trigger; no separate artifact. |
| A skill needs aesthetics, boundaries, and workflow, not just trigger words | Existing repo rule | Already covered by `methodology-intake` skill admission criteria; no new baseline. |
| Upstream install/update commands | No-op | Do not add installer or vendor upstream AGPL project into this repo. |

## Why Not Baseline

This guidance should only activate when a user is producing a social Live Photo
card. Making it always-on would add media-production constraints to unrelated
engineering work.

## Risks

- Licensing: upstream repository is AGPL-3.0. Avoid verbatim imports and assets
  unless a deliberate license review approves that path.
- Platform behavior: Live Photo publishing constraints can change. Verify the
  target platform and packaging tool before promising ready-to-post output.
- Tooling: `.pvt` generation may not exist locally. Deliver a clear manual
  publishing note when packaging is unavailable.

## Revisit Trigger

Revisit this skill after one real use that produces a Live Photo card with
locally verified preview output and a documented platform-publish result.

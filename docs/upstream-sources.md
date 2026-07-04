# Upstream Sources

This file tracks external repositories whose skill material is imported into
this repository.

Every imported source must have:

- Source repository
- Imported paths
- Local target paths
- License name
- License URL or file path
- Copyright notice
- Verification date
- Import or refresh commit
- Required obligations

Do not import from a repository with unclear or incompatible licensing.

## mattpocock/skills

Source repository:

```text
https://github.com/mattpocock/skills
```

Imported upstream paths:

```text
skills/engineering/diagnose
skills/engineering/grill-with-docs
skills/engineering/improve-codebase-architecture
skills/engineering/prototype
skills/engineering/setup-matt-pocock-skills
skills/engineering/tdd
skills/engineering/to-issues
skills/engineering/to-prd
skills/engineering/triage
skills/engineering/zoom-out
```

Local target paths:

```text
skills/engineering/diagnose
skills/engineering/grill-with-docs
skills/engineering/improve-codebase-architecture
skills/engineering/prototype
skills/engineering/setup-matt-pocock-skills
skills/engineering/tdd
skills/engineering/to-issues
skills/engineering/to-prd
skills/engineering/triage
skills/engineering/zoom-out
```

License:

```text
MIT License
```

License source:

```text
https://github.com/mattpocock/skills/blob/main/LICENSE
```

Copyright notice:

```text
Copyright (c) 2026 Matt Pocock
```

Verification date:

```text
2026-05-21
```

Import commit recorded at initial import:

```text
b8be62f Merge branch 'main' of https://github.com/mattpocock/skills
```

Verification method:

- Checked the upstream GitHub `LICENSE` file.
- Checked the upstream `skills/engineering` directory listing.
- Confirmed the imported skill names match the upstream engineering directory.

Required obligations:

- Preserve the MIT copyright and permission notice.
- Do not present imported skills as original work from this repository.
- Keep `NOTICE.md` and this source registry updated when importing or refreshing.

Local modifications (permitted by MIT; re-apply or re-evaluate on refresh):

- 2026-07-03: `improve-codebase-architecture/SKILL.md` — added a lightweight
  routing note (skip the HTML report for single-module questions).

## multica-ai/andrej-karpathy-skills

Source repository:

```text
https://github.com/multica-ai/andrej-karpathy-skills
```

Imported upstream paths:

```text
No upstream files are imported verbatim.
```

Local target paths:

```text
baselines/karpathy-principles
```

License:

```text
MIT License, as stated by the upstream README.
```

License source:

```text
https://github.com/multica-ai/andrej-karpathy-skills#license
```

Copyright notice:

```text
No upstream copyright notice was identified in the README. Preserve upstream
project attribution when discussing this adapted baseline.
```

Verification date:

```text
2026-06-16
```

Import commit recorded at initial adaptation:

```text
Not recorded. The baseline is an adapted tool-neutral rule pack, not a verbatim
file import.
```

Verification method:

- Checked the upstream GitHub README.
- Confirmed the source describes four principles and states MIT licensing.
- Adapted the principles into local wording and managed-block adapters.

Required obligations:

- Preserve source attribution in the baseline pack.
- Do not present the original upstream Claude Code plugin or examples as
  authored by this repository.
- Re-check license details before any future verbatim import.

## op7418/guizang-social-card-skill

Source repository:

```text
https://github.com/op7418/guizang-social-card-skill
```

Related public methodology source:

```text
https://x.com/op7418/status/2072510211626336740
```

Imported upstream paths:

```text
No upstream files are imported verbatim.
```

Local target paths:

```text
skills/media/social-live-photo-card
```

License:

```text
GNU Affero General Public License v3.0, as stated by the upstream GitHub
repository license.
```

License source:

```text
https://github.com/op7418/guizang-social-card-skill/blob/main/LICENSE
```

Copyright notice:

```text
No upstream files are imported. Preserve attribution to op7418 / 歸藏(guizang.ai)
when discussing the public methodology source.
```

Verification date:

```text
2026-07-03
```

Import or refresh commit:

```text
Not applicable. The local skill is a reference-based adaptation, not a verbatim
import.
```

Verification method:

- Read the public X post through X oEmbed and a third-party public renderer.
- Checked the upstream GitHub repository, README, and LICENSE.
- Classified each source idea through `methodology-intake`.
- Created local wording and did not copy upstream files, templates, assets,
  scripts, or skill text.

Required obligations:

- Do not present the upstream project or examples as authored by this
  repository.
- Do not import upstream files, assets, templates, or scripts without a separate
  AGPL-3.0 license review.
- Keep `skills/media/social-live-photo-card/references/source-intake.md`
  updated with adoption evidence and platform caveats.

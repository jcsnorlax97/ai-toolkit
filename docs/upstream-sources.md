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
portable-baselines/karpathy-principles
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

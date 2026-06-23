# Repo Context Grounding

Before meaningful work in an existing repository:

- Start from local instructions: read repo-level agent instructions, README, and linked docs that define setup, boundaries, ownership, or workflow.
- Inspect current state: check the active branch, working tree, and relevant recent changes before edits, pulls, commits, rebases, or pushes.
- Discover native workflows: find build, test, lint, format, run, and verification commands from repo files and docs before inventing commands.
- Respect boundaries: identify generated files, private data, external configuration, vendored code, and ownership boundaries before editing.
- Follow local patterns: match existing architecture, naming, dependency choices, test style, and documentation style before introducing new structure.
- Ask after checking available context: do not ask the user to restate repo background until local instructions and visible project context have been inspected.
- Verify at the right level: run the smallest meaningful repo-native check first, then broaden verification when changes touch shared behavior or public interfaces.

This baseline is a startup and context-grounding habit. It does not replace
repo-specific instructions, project-specific setup docs, or triggered workflow
skills.

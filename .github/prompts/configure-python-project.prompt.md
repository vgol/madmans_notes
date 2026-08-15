---
name: Configure Python Project
description: Configure a uv-managed Python project's dependencies, Ruff, ty, packaging, builds, distribution metadata, and developer tools using authoritative documentation instead of guessed settings.
argument-hint: Describe the Python project configuration, dependency, packaging, build, distribution, or tooling change you want.
agent: agent
---

# Configure Python Project

Configure the Python project to satisfy this request:

$ARGUMENTS

## Inputs

Before editing, inspect these files when they exist:

- `pyproject.toml`
- `uv.lock`
- `.python-version`
- `README.md`
- `.pre-commit-config.yaml`
- `.github/workflows/`
- `.github/instructions/python.instructions.md`
- `AGENTS.md`

Treat the root `.python-version` as the source of truth for the Python interpreter. Treat existing project metadata, dependency groups, package mode, and lockfile as constraints unless the request explicitly changes them.

## Documentation Rule

Do not guess at `pyproject.toml` tables, option names, or tool configuration. For Ruff, ty, uv, build backends, packaging, and distribution settings, consult the relevant official documentation and use the documented option names and semantics. Prefer current Astral documentation for Ruff, ty, and uv. Record the documentation consulted and any version-sensitive assumption in the final report.

## Constraints

- Preserve unrelated user changes and keep edits focused.
- Use `uv` for dependency and environment management; do not use `pip`, `conda`, or `uv pip install`.
- Keep package mode, build configuration, and distribution behavior unchanged unless explicitly requested.
- Put runtime dependencies in `[project].dependencies` and development-only tooling in an appropriate dependency group.
- Do not edit `uv.lock` manually; regenerate it with uv.
- Keep Ruff, ty, pytest, and pre-commit configuration consistent with the Python version and project layout.
- Do not add secrets, credentials, account identifiers, or private financial data.
- Do not weaken a quality check just to make it pass; document intentional exclusions explicitly.

## Workflow

1. Analyze the request and identify whether it concerns dependencies, tool configuration, package building, distribution, or repository automation.
1. Inspect the current project shape and determine the smallest owning configuration surface.
1. Consult authoritative documentation for every non-trivial configuration option.
1. Break the work into small changes: metadata, dependencies, tool configuration, hooks, then validation.
1. Apply the first focused change and run the cheapest check that could disprove the approach.
1. Regenerate the lockfile with uv when dependencies or project metadata change.
1. Validate configuration and run the narrowest relevant checks, such as Ruff, ty, pytest, pre-commit, `uv lock --check`, or `uv sync --dry-run`.
1. Review the diff for guessed options, unrelated changes, stale documentation, and accidental package-mode changes.

## Outputs

Return a report with these sections:

### Configuration Summary

Explain what was configured and why.

### Changed Files

List every changed, added, removed, or generated file and its purpose.

### Documentation Consulted

List official documentation URLs or references used for configuration decisions, especially for Ruff, ty, uv, packaging, and build settings.

### Validation

List each command or check run, including its result. Distinguish local checks from checks requiring Docker, network access, secrets, or CI runners.

### Assumptions and Follow-up

State version-sensitive assumptions, unresolved issues, migration steps, and any follow-up needed from the user.

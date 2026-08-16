---
description: "Use when creating or modifying GitHub Actions CI workflows, pre-commit configuration, or development tooling in this repository."
name: "CI Workflow Guidelines"
applyTo: ".github/workflows/**, .pre-commit-config.yaml"
---

# CI Workflow Guidelines

## Overview

The CI system for this repository is the responsibility of the **Development Infrastructure Engineer** specialist (see [AGENTS.md](../../AGENTS.md)). It consists of two layers:

- **Local pre-commit hooks** — run on every `git commit` (fast stage) or on-demand (named stages).
- **GitHub Actions CI** — the `ci-pr-check.yml` workflow that runs on pull requests and pushes to `main`.

## GitHub Actions Workflow: `ci-pr-check.yml`

File: `.github/workflows/ci-pr-check.yml`

### Triggers

- `pull_request` — all pull requests targeting any branch.
- `push` to `main` — every merge to the default branch.
- **No tag triggers.** Tag-based releases use a separate dedicated workflow.

### Three Independent Jobs

The workflow is deliberately split into three independent jobs so each gate can be inspected, re-run, or skipped in isolation.

| Job           | Pre-commit invocation(s)                                                                                                                                              | Tools run                                                          | Label added on success |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------- |
| `lint-format` | `pre-commit run ruff-check`, `pre-commit run ruff-format`, `pre-commit run markdownlint-cli2`, `pre-commit run mdformat` (all with `--hook-stage manual --all-files`) | `markdownlint-cli2`, `mdformat`, `ruff check --fix`, `ruff format` | `✅ ruff`              |
| `type-check`  | `pre-commit run ty-check --hook-stage manual --all-files`                                                                                                             | `ty check`                                                         | `✅ ty`                |
| `unit-tests`  | `pre-commit run pytest --hook-stage manual --all-files`                                                                                                               | `pytest tests`                                                     | `✅ pytest`            |

Each job:

1. Checks out the repository.
1. Sets up Python using the version in `.python-version`.
1. Installs uv at the pinned version and restores the uv cache.
1. Runs `uv sync --locked` to reproduce the exact locked environment.
1. Invokes the stage-specific pre-commit hook(s) with `--all-files --show-diff-on-failure`.
1. On success for a pull request event, adds the corresponding colored label via `actions/github-script`.

### Permissions

The workflow requires `issues: write` and `pull-requests: write` to add labels. Content access uses `contents: read`.

### Action Pins

All `uses:` references must be pinned to a full commit SHA with a version comment, e.g.:

```yaml
uses: actions/checkout@<sha> # v7.0.1
```

Never use floating tags (`@v3`, `@main`) in production workflows.

## Pre-commit Configuration: `.pre-commit-config.yaml`

### Stages

| Stage                  | When it runs                                     | Hooks included                                                                                            |
| ---------------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| `pre-commit` (default) | On every `git commit`                            | YAML check, end-of-file fixer, trailing-whitespace, `ruff check --fix`, `ruff format`, `uv-lock`          |
| `manual`               | Explicit on-demand and CI job-specific hook runs | `ruff check --fix`, `ruff format`, `markdownlint-cli2`, `mdformat`, `ty check`, `pytest tests`, `uv-lock` |

The `pre-commit` stage is the local commit-time gate. CI jobs invoke specific hook IDs with `--hook-stage manual` so they do not run unrelated manual hooks.

### Running Stages Locally

```bash
# Fast commit gate (runs automatically on git commit)
uv run pre-commit run --all-files

# Lint & formatting hooks (mirror CI lint-format job)
uv run pre-commit run ruff-check --hook-stage manual --all-files
uv run pre-commit run ruff-format --hook-stage manual --all-files
uv run pre-commit run markdownlint-cli2 --hook-stage manual --all-files
uv run pre-commit run mdformat --hook-stage manual --all-files

# Type checking (mirrors CI type-check job)
uv run pre-commit run ty-check --hook-stage manual --all-files

# Unit tests (mirrors CI unit-tests job)
uv run pre-commit run pytest --hook-stage manual --all-files
```

### Hook Conventions

- All hooks use `language: unsupported` with `uv run <tool>` entry points so they rely on the uv-managed virtual environment rather than a pre-commit-managed environment.
- Ruff hooks run on changed Python and notebook files in the `pre-commit` stage and on all files when invoked with `--all-files`.
- pytest and ty hooks use `pass_filenames: false` and run on all files when invoked from CI or local manual runs.
- `ty check` runs on all files for consistency regardless of which files changed.
- Never pin tool versions directly in hook entries; versions are controlled by `uv.lock`.

## Label Management

The three labels added by the workflow must exist in the repository before the workflow runs:

| Label       | Suggested color    |
| ----------- | ------------------ |
| `✅ ruff`   | `#2ea44f` (green)  |
| `✅ ty`     | `#0075ca` (blue)   |
| `✅ pytest` | `#e4e669` (yellow) |

Labels are created once via the GitHub UI or the API. The workflow only adds labels; it does not remove them. Stale labels from previous runs are the responsibility of the PR author or reviewer.

## Updating the Workflow

- When adding a new quality tool, add a corresponding pre-commit hook to the appropriate stage and update the matching CI job.
- When changing a tool version, update `uv.lock` via `uv lock` and verify that the pinned action SHAs remain current.
- Run `uv run pre-commit autoupdate` periodically and review all resulting changes before merging.
- When changing the workflow YAML, validate syntax with `uv run pre-commit run check-yaml --all-files` before pushing.

## Routing

Changes to `.github/workflows/`, `.pre-commit-config.yaml`, devcontainer configuration, `.vscode/` settings, and repository automation belong to the **Development Infrastructure Engineer** specialist. Do not route these tasks to the Python Developer or Data Finance Analyst.

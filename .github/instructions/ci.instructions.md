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

The workflow is deliberately split into three independent jobs so each stage can be inspected, re-run, or skipped in isolation.

| Job | Stage name | Tools run | Label added on success |
|-----|-----------|-----------|------------------------|
| `lint-format` | `lint-format` | `markdownlint-cli2`, `mdformat`, `ruff check --fix`, `ruff format` | `✅ ruff` |
| `type-check` | `type-check` | `ty check` | `✅ ty` |
| `unit-tests` | `unit-tests` | `pytest tests` | `✅ pytest` |

Each job:
1. Checks out the repository.
2. Sets up Python using the version in `.python-version`.
3. Installs uv at the pinned version and restores the uv cache.
4. Runs `uv sync --locked` to reproduce the exact locked environment.
5. Invokes `uv run pre-commit run --hook-stage <stage> --all-files --show-diff-on-failure`.
6. On success for a pull request event, adds the corresponding colored label via `actions/github-script`.

### Permissions

The workflow requires `pull-requests: write` to add labels. Content access uses `contents: read`.

### Action Pins

All `uses:` references must be pinned to a full commit SHA with a version comment, e.g.:

```yaml
uses: actions/checkout@<sha> # v7.0.1
```

Never use floating tags (`@v3`, `@main`) in production workflows.

## Pre-commit Configuration: `.pre-commit-config.yaml`

### Stages

| Stage | When it runs | Hooks included |
|-------|-------------|----------------|
| `pre-commit` (default) | On every `git commit` | YAML check, end-of-file fixer, trailing-whitespace, `ruff check --fix`, `ruff format` |
| `lint-format` | CI lint-format job; `uv run pre-commit run --hook-stage lint-format --all-files` | `markdownlint-cli2`, `mdformat`, `ruff check --fix`, `ruff format` |
| `type-check` | CI type-check job; `uv run pre-commit run --hook-stage type-check --all-files` | `ty check` |
| `unit-tests` | CI unit-tests job; `uv run pre-commit run --hook-stage unit-tests --all-files` | `pytest tests` |
| `manual` | Explicit on-demand; `uv run pre-commit run --hook-stage manual --all-files` | `uv-lock` |

The `pre-commit` stage is the **fast local gate** and must stay quick (< 10 s). The three named CI stages mirror the three CI jobs and can be invoked locally for debugging.

### Running Stages Locally

```bash
# Fast commit gate (runs automatically on git commit)
uv run pre-commit run --all-files

# Lint & formatting stage (mirrors CI lint-format job)
uv run pre-commit run --hook-stage lint-format --all-files

# Type checking (mirrors CI type-check job)
uv run pre-commit run --hook-stage type-check --all-files

# Unit tests (mirrors CI unit-tests job)
uv run pre-commit run --hook-stage unit-tests --all-files
```

### Hook Conventions

- All hooks use `language: unsupported` with `uv run <tool>` entry points so they rely on the uv-managed virtual environment rather than a pre-commit-managed environment.
- Ruff and pytest hooks have `pass_filenames: false`; they operate on the whole project but are gated by `types_or: [python, jupyter]` so they only trigger when relevant files are staged.
- `ty check` runs on all files for consistency regardless of which files changed.
- Never pin tool versions directly in hook entries; versions are controlled by `uv.lock`.

## Label Management

The three labels added by the workflow must exist in the repository before the workflow runs:

| Label | Suggested color |
|-------|----------------|
| `✅ ruff` | `#2ea44f` (green) |
| `✅ ty` | `#0075ca` (blue) |
| `✅ pytest` | `#e4e669` (yellow) |

Labels are created once via the GitHub UI or the API. The workflow only adds labels; it does not remove them. Stale labels from previous runs are the responsibility of the PR author or reviewer.

## Updating the Workflow

- When adding a new quality tool, add a corresponding pre-commit hook to the appropriate stage and update the matching CI job.
- When changing a tool version, update `uv.lock` via `uv lock` and verify that the pinned action SHAs remain current.
- Run `uv run pre-commit autoupdate` periodically and review all resulting changes before merging.
- When changing the workflow YAML, validate syntax with `uv run pre-commit run check-yaml --all-files` before pushing.

## Routing

Changes to `.github/workflows/`, `.pre-commit-config.yaml`, devcontainer configuration, `.vscode/` settings, and repository automation belong to the **Development Infrastructure Engineer** specialist. Do not route these tasks to the Python Developer or Data Finance Analyst.

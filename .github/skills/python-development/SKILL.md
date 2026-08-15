---
name: python-development
description: "Develop, refactor, test, and validate Python code in this uv-managed workspace. Use for Python modules, notebooks, Pydantic models, parsers, pytest, Ruff, ty, dependency changes, and repository quality checks."
user-invocable: true
---

# Python Development

## Purpose

Use this skill for repeatable Python implementation and validation in this repository. Read the applicable file instructions and `AGENTS.md` first; this skill defines the execution workflow and does not replace those rules.

## Before Editing

1. Read the relevant source, tests, documentation, `pyproject.toml`, and `.python-version`.
1. Identify the smallest owning module or function.
1. State a falsifiable behavior hypothesis and the narrowest check that could disprove it.
1. Preserve unrelated user changes, generated notebook output, and private financial data.

## Implementation Rules

- Use the repository's `uv` environment and existing dependencies.
- Add runtime dependencies with `uv add`; do not use `pip`, `conda`, or `uv pip install`.
- Prefer small functions with explicit inputs, outputs, and modern type hints.
- Do not use `typing.Any`.
- Do not use `object` as a vague substitute for a meaningful type; define a precise alias or union for heterogeneous values.
- Keep transformations deterministic and preserve public APIs unless a change is intentional.
- For Pydantic models, use `Annotated[type, Field(...)]` when field metadata or aliases are needed, and annotate fields even when they have defaults.
- For streams and large files, preserve lazy iteration unless eager materialization is explicitly required.
- Protect credentials, account identifiers, bank exports, and unnecessary raw personal data.

## Workflow Selection

Choose one named workflow based on the change:

| Workflow                   | Use when                                                                | Command                                                              |
| -------------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Focused Python change      | A Python module or focused test changed                                 | `uv run pre-commit run --files path/to/changed.py`                   |
| Fast commit checks         | On every commit; hygiene, Ruff lint, and Ruff format only               | `uv run pre-commit run --all-files`                                  |
| Manual review / full check | Before review, or whenever ty, pytest, Markdown, and uv-lock are needed | `uv run pre-commit run --hook-stage manual --all-files`              |
| Dependency change          | `pyproject.toml` or `uv.lock` changed                                   | `uv lock --check`, `uv sync --dry-run`, then the manual review check |
| Notebook change            | A notebook changed                                                      | `uv run pre-commit run --files path/to/notebook.ipynb`               |

The workflow names above are skill workflows. Pre-commit supplies the executable hooks; do not create a second set of ad hoc commands for the same checks.

The hooks are split into two pre-commit stages. The `pre-commit` stage (fast) runs on every `git commit` and with `uv run pre-commit run --all-files`. The `manual` stage (slower) must be invoked explicitly with `--hook-stage manual` and is never triggered by a commit.

## Validation Workflow

After the first substantive edit, run the narrowest behavior check available before making further edits. For Python changes, prefer a focused test or a small executable parse/check.

The repository uses two pre-commit stages:

- **`pre-commit` stage** (fast, runs on every `git commit`): YAML, end-of-file, trailing-whitespace, `ruff check --fix`, `ruff format`
- **`manual` stage** (slower, must be invoked explicitly): `ty check`, `pytest`, `markdownlint-cli2`, `mdformat`, `uv-lock`

Use the repository-managed pre-commit workflow for the fast commit check:

```bash
uv run pre-commit run --all-files
```

To run the full manual review (ty, pytest, Markdown, uv-lock):

```bash
uv run pre-commit run --hook-stage manual --all-files
```

To run a specific manual hook:

```bash
uv run pre-commit run --hook-stage manual ty-check --all-files
uv run pre-commit run --hook-stage manual pytest --all-files
```

Do not replace the configured commands with `ruff format --check` or `ruff check` without `--fix`. If a focused check is needed before pre-commit, use the same `uv run` environment and the user's preferred auto-fixing commands:

```bash
uv run ruff format path/to/changed.py
uv run ruff check --fix path/to/changed.py
uv run ty check path/to/changed.py
```

The repository currently has no tests. A pytest run may therefore return exit code `5` for no tests collected; report that condition clearly rather than calling it a test failure caused by the code.

## Dependencies

After changing `pyproject.toml` dependencies:

```bash
uv lock --check
uv sync --dry-run
```

Do not edit `uv.lock` manually.

## Completion Report

Report:

- Changed files
- Behavior implemented
- Validation commands and results
- Missing tests or environment limitations
- Assumptions that remain relevant

---
description: "Use when creating or modifying Python files or Jupyter notebooks in this uv-managed workspace."
name: "Python and Notebook Guidelines"
applyTo: "**/*.py, **/*.ipynb"
---

# Python and Notebook Guidelines

## Stack

- Use the Python version pinned in the repository root `.python-version` file. Treat `pyproject.toml` as the compatibility constraint and do not duplicate the pinned version in instructions.
- Use `uv` for environments and dependencies; use the repository's existing `.venv` and lockfile.
- Install / uninstall dependencies with `uv add` / `uv remove` and regenerate the lock-file with `uv lock`.
- Don't use `pip` or `conda`. Don't use `uv pip install` either.
- This is a non-package project for experiments, notes, notebooks, and VS Code's Interactive Window.
- Current project use the following products in it's dev cycle: `pytest`, `ruff`, and `ty`.
- ty is the strict Python language service and static type checker; it provides hover, completions, go-to-definition, find-references, and type diagnostics.
- Do not add Pylance, Pyright, or another general Python language server; `python.languageServer: "None"` in `.vscode/settings.json` suppresses Pylance. It has no effect on Ruff or ty.
- Ruff also runs a language server (`ruff server`, always on in v2.x). This is intentional and complementary — Ruff's server handles linting diagnostics, formatting, and code actions (`source.fixAll.ruff`, `source.organizeImports.ruff`) only, with no overlap on hover, completions, or type checking. Both servers must be active for the configured `[python]` formatting and code-action-on-save workflow to function.

## Before Editing

- Read the relevant source, notebook, tests, `pyproject.toml`, and nearby documentation before changing code.
- Check `.python-version` when selecting an interpreter or diagnosing environment differences - even more generally - don't change
  Python and package versions, until asked explicitly.
- Identify the smallest owning file or function and form a testable hypothesis about the requested behavior.
- Preserve unrelated user changes, generated outputs, and notebook work unless the task explicitly includes them.

## Python Code

- Prefer clear, small functions with explicit inputs and outputs.
- Use descriptive names and meaningful types; avoid one-letter names except for conventional short-lived indices.
- Keep imports explicit and avoid hidden global state in code intended for reuse from notebooks.
- Prefer the standard library and existing project dependencies before adding a new dependency.
- Keep data transformations deterministic and make assumptions visible in function names, parameters, or nearby documentation.
- Preserve existing public APIs unless the task explicitly requests a breaking change.
- Add focused tests when behavior changes, a bug is fixed, or a reusable helper gains non-trivial logic.

## Dependencies and Project Shape

- Keep runtime dependencies in `[project].dependencies` in `pyproject.toml`.
- Put development-only tools in an appropriate uv dependency group when that structure is present.
- Do not add package-building configuration or package layout unless explicitly requested.
- After dependency or `pyproject.toml` changes, run `uv lock --check` and `uv sync --dry-run` when available.
- Do not edit `uv.lock` manually; regenerate it with uv.

## Tests and Validation

- Validate immediately after the first substantive edit with the narrowest relevant check.
- Use `pytest` for focused behavior and regression tests; prefer a targeted test path before the full suite.
- Use `ruff check --fix` for safe automatic lint fixes, followed by `ruff format` for formatting.
- Use `ty check` for type-checking when the changed code has meaningful type contracts.
- Run `pre-commit run --all-files` when changing repository-wide Python quality configuration or before committing a broad change.
- The fast `pre-commit` stage quality gate (every commit) runs YAML validation, end-of-file and whitespace fixes, `uv run ruff check --fix`, and `uv run ruff format`; invoke with `uv run pre-commit run --all-files`.
- The manual stage additionally runs `uv run ty check`, `uv run pytest`, Markdown linting and formatting, and the `uv-lock` check; invoke with `uv run pre-commit run --hook-stage manual --all-files`.
- Report unavailable commands, missing dependencies, or environment limitations instead of treating them as passing checks.
- Do not weaken tests, lint rules, or type checks just to make validation pass.
- Python code should be type annotated in both real python files and notebook cells.
- Don't use or install `mypy` or other type checkers; use `ty`.
- Don't use `typing.Any`, etc.. Prefer to use modern type hints notations, e.g. `list[str]` instead of `List[str]`, `dict[str, int]` instead of `Dict[str, int]`, etc.
- Do not use `object` as a vague substitute for a meaningful type; define a precise type alias or union for heterogeneous values.
- Don't use empty hints for compound types, e.g. `list` instead of `list[str]`, `dict` instead of `dict[str, int]`, etc. Nested types matter!

## Pre-commit

- Keep the repository hook definition in `.pre-commit-config.yaml`.
- Install the project environment and hook with `uv sync` and `uv run pre-commit install`.
- The hooks are split into two stages: **`pre-commit`** (fast, runs on every commit) and **`manual`** (slower, must be invoked explicitly).
- **`pre-commit` stage** (runs with `uv run pre-commit run --all-files` and on every `git commit`): YAML validation, end-of-file fixer, trailing-whitespace, `ruff check --fix`, `ruff format`.
- **`manual` stage** (run with `uv run pre-commit run --hook-stage manual --all-files`): `ty check`, `pytest`, `markdownlint-cli2`, `mdformat` (GFM/frontmatter), `uv-lock`.
- The hooks invoke tools through `uv run` so local commits use the versions locked in `uv.lock`.
- Ruff hooks run only when Python or notebook files are part of the commit; use `--all-files` for an explicit repository-wide run.
- Update hook revisions deliberately with `uv run pre-commit autoupdate`; review the resulting lock and configuration changes.
- The pytest hook treats exit code 5 (no tests collected) as a passing condition while the repository has no tests; all other pytest failures remain blocking.

## Notebooks

- Preserve valid `.ipynb` JSON when editing notebooks.
- Keep every cell as a JSON object in the top-level `cells` array.
- Set each cell's `metadata.language` to `python` or `markdown` as appropriate.
- Preserve a unique `metadata.id` on every existing cell; new cells do not require an ID.
- Prefer small cells that can run in both a Jupyter kernel and VS Code's Interactive Window.
- Keep a logical progression: imports and setup, input loading, profiling, transformation, analysis, visualization, and conclusions.
- Make input paths, date ranges, category mappings, units, and assumptions explicit.
- Avoid embedding sensitive raw financial data or credentials in cells, outputs, plots, or committed examples.
- Clear stale outputs when they obscure review or contain sensitive data; preserve useful outputs when the task depends on them.
- Keep outputs and metadata changes focused on the task.
- In user-facing responses, refer to cells by visible number, never by internal cell ID.

## Notebook JSON Contract

When generating or editing notebook content:

- Use valid JSON, not a Python or JavaScript object literal.
- Keep notebook cells inside the top-level `cells` array.
- Make every cell a valid JSON object with the appropriate `cell_type`, `metadata`, and `source` fields.
- Include `metadata.language` with `python` for code cells and `markdown` for markdown cells.
- Existing cells must retain their unique `metadata.id`; new cells may omit an ID.
- Do not expose internal cell IDs in user-facing explanations; use visible cell numbers starting at 1.

## Collaboration

- For finance-specific questions, preserve the analyst's definitions, assumptions, reconciliation rules, and privacy decisions.
- For infrastructure, VS Code, devcontainer, CI, or customization changes, route to the owning specialist instead of expanding a Python task.
- For repeatable Python implementation and validation workflows, use [Python Development](../skills/python-development/SKILL.md).
- When receiving a delegated implementation slice, return changed files, implementation summary, validation results, assumptions, and unresolved issues.

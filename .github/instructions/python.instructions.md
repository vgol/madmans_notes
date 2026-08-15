---
description: "Use when creating or modifying Python files or Jupyter notebooks in this uv-managed workspace."
name: "Python and Notebook Guidelines"
applyTo: "**/*.py, **/*.ipynb"
---
# Python and Notebook Guidelines

## Stack

- Use the Python version pinned in the repository root `.python-version` file. Treat `pyproject.toml` as the compatibility constraint and do not duplicate the pinned version in instructions.
- Use `uv` for environments and dependencies; use the repository's existing `.venv` and lockfile.
- Install / uninstall dependencies with `uv add` / `uv remove` and regenerate the lockfile with `uv lock`.
- Don't use `pip` or `conda`. Don't use uv pip install either.
- This is a non-package project for experiments, notes, notebooks, and VS Code's Interactive Window.
- Current project dependencies include `ipykernel`, `pytest`, `ruff`, and `ty`.

## Before Editing

- Read the relevant source, notebook, tests, `pyproject.toml`, and nearby documentation before changing code.
- Check `.python-version` when selecting an interpreter or diagnosing environment differences.
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
- Use `ruff check` for linting and `ruff format --check` when formatting is relevant.
- Use `ty check` for type-checking when the changed code has meaningful type contracts.
- Report unavailable commands, missing dependencies, or environment limitations instead of treating them as passing checks.
- Do not weaken tests, lint rules, or type checks just to make validation pass.
- Python code should be type annotated in both real python files and notebook cells.
- Don't use or install `mypy` or other type checkers; use `ty`.
- Don't use `typing.Any`, etc.. Prefer to use modern type hints notations, e.g. `list[str]` instead of `List[str]`, `dict[str, int]` instead of `Dict[str, int]`, etc.
- Don't use empty type hints, e.g. `list` instead of `list[str]`, `dict` instead of `dict[str, int]`, etc. Nested types matter!

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
- When receiving a delegated implementation slice, return changed files, implementation summary, validation results, assumptions, and unresolved issues.

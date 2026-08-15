---
description: "Use when creating or modifying Python files or Jupyter notebooks in this uv-managed Python 3.14 workspace."
name: "Python and Notebook Guidelines"
applyTo: ["**/*.py", "**/*.ipynb"]
---
# Python and Notebook Guidelines

## Stack
- Target Python 3.14, as declared in `.python-version` and `pyproject.toml`.
- Use `uv` for environments and dependencies; use the repository's existing `.venv` and lockfile.
- This is a non-package project for experiments, notes, notebooks, and VS Code's Interactive Window.
- Current project dependencies include `ipykernel`, `pytest`, `ruff`, and `ty`.

## Python Code
- Prefer clear, small functions and runnable examples suitable for experimentation.
- Follow existing code style and avoid adding abstractions that are not needed by the current task.
- Keep imports explicit and avoid hidden global state in code intended for reuse from notebooks.
- Run the narrowest relevant validation after changes: `pytest`, `ruff check`, or `ty check` as appropriate.

## Notebooks
- Preserve valid `.ipynb` JSON when editing notebooks.
- Keep every cell as a JSON object in the top-level `cells` array.
- Set each cell's `metadata.language` to `python` or `markdown` as appropriate.
- Preserve a unique `metadata.id` on every existing cell; new cells do not require an ID.
- Prefer small cells that can run in both a Jupyter kernel and VS Code's Interactive Window.
- Keep outputs and metadata changes focused on the task.
- In user-facing responses, refer to cells by visible number, never by internal cell ID.

## Dependencies and Project Shape
- Keep runtime dependencies in `[project].dependencies` in `pyproject.toml`.
- Put development-only tools in an appropriate uv dependency group when that structure is present.
- Do not add package-building configuration or package layout unless explicitly requested.

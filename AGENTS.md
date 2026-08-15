# Repository Guidelines

## Scope

- This repository is an experimental Python / Jupyter workspace for notebooks and calculations.
- Keep changes small and focused; preserve unrelated user changes.
- Do not turn the repository into a distributable package unless explicitly requested.

## Tooling

- Use Python 3.14 as declared by `.python-version`, `pyproject.toml`, and the devcontainer.
- Use `uv` for environment and dependency management. Do not introduce another environment manager.
- The devcontainer uses a named workspace volume and clones the repository into `/workspace/madmans_notes`.
- Keep the existing VS Code Python, Ruff, Jupyter, debugpy, and ty extensions unless a tooling change is requested.

## Dependencies

- Keep project dependencies in `[project].dependencies` in `pyproject.toml`.
- Use an appropriate uv dependency group for development-only tools.
- The project is intentionally non-package and keeps `tool.uv.package = false`.
- After dependency or `pyproject.toml` changes, run `uv lock --check` and `uv sync --dry-run` when available.

## Notebooks

- Preserve valid notebook JSON and existing cell metadata when editing `.ipynb` files.
- Prefer small, runnable cells that work in both Jupyter and the VS Code Interactive Window.
- Refer to notebook cells by visible cell number in user-facing messages, never by internal IDs.

## Validation

- Run the narrowest relevant test, lint, or type check after code changes.
- Use `pytest` for tests, `ruff` for linting and formatting checks, and `ty` for type checking when applicable.
- Validate changed configuration files and report checks that cannot run in the current environment.

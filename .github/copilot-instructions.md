# Project Guidelines

## Project Scope
- Treat this repository as a Python project for experimentation, notes, notebooks, and VS Code's Interactive Window.
- Do not add package-building configuration or package layout unless the user explicitly asks to turn the project into a distributable package.
- Keep runtime dependencies in `project.dependencies` and development tools in the appropriate uv dependency group.
- Use the existing Python version requirement and `uv` workflow in `pyproject.toml`; do not replace it with another environment manager without a specific request.

## Notebooks
- When creating or editing `.ipynb` files, preserve valid notebook JSON.
- Every cell must be a JSON object in the top-level `cells` array with `metadata.language` set to `markdown` or `python` as appropriate.
- Existing cells must retain a unique `metadata.id`; new cells do not require an ID.
- Refer to notebook cells by their visible cell number in user-facing messages, never by internal cell IDs.
- Prefer small, runnable cells that work in both a Jupyter kernel and VS Code's Interactive Window.

## Validation
- After changing `pyproject.toml` or dependencies, run `uv lock --check` and a focused `uv sync --dry-run` when available.
- After changing Python code, run the narrowest relevant test, lint, or type-check command.
- Avoid modifying unrelated working-tree changes.

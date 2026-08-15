---
name: Modify Dev Container
description: Safely modify this repository's Docker Compose-based VS Code devcontainer while preserving its Python, uv, notebook, and Interactive Window workflow.
argument-hint: Describe the devcontainer change you want, including any required tools, versions, extensions, environment variables, or commands.
agent: agent
---

Modify the repository's devcontainer configuration to satisfy this request:

$ARGUMENTS

Before editing:

- Inspect `.devcontainer/devcontainer.json`, `.devcontainer/docker-compose.yml`, `.devcontainer/Dockerfile`, `.devcontainer/test_tools.sh`, `.devcontainer/devcontainer-lock.json`, `pyproject.toml`, and `.github/copilot-instructions.md` when they exist.
- Identify which file directly owns the requested behavior and make the smallest compatible change.
- Preserve the current Docker Compose service and workspace wiring unless the request explicitly requires changing it.
- Preserve the Python, uv, Jupyter notebook, and VS Code Interactive Window workflow.
- Keep this repository as a non-package project unless the request explicitly asks for package building.
- Treat the root `.python-version` file as the source of truth for the Python version. Keep `pyproject.toml`, devcontainer images, features, and commands compatible with it, and flag a mismatch before choosing a value when the request does not specify one.
- Keep `postCreateCommand` and any referenced scripts or Make targets valid. Do not introduce a command that has no corresponding file or target.
- Prefer existing devcontainer features and project conventions over adding custom installation logic.

After editing:

- Validate JSON, YAML, shell syntax, and TOML for every changed configuration file using available project tools.
- Run the narrowest relevant devcontainer or tool-validation check available. For dependency or Python-version changes, run `uv lock --check` and `uv sync --dry-run` when available.
- Review the diff for unrelated changes and preserve user modifications.
- Report changed files, validation performed, and any checks that could not run because container rebuild or Docker access is unavailable.

#!/usr/bin/env bash
set -euo pipefail

# The repository is bind-mounted at workspaceFolder by the devcontainer runtime
# (devcontainers/ci in CI, VS Code Dev Containers locally). No manual clone needed.
# postCreateCommand is invoked from workspaceFolder, so no explicit cd is needed.

uv python install
uv venv --clear
uv sync --locked
uv run pre-commit install

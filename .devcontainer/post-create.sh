#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/workspace/madmans_notes"
REPO_URL="https://github.com/vgol/madmans_notes.git"

if [ -d "$REPO_DIR/.git" ]; then
  cd "$REPO_DIR"
else
  git clone "$REPO_URL" "$REPO_DIR"
  cd "$REPO_DIR"
fi

uv python install
uv venv --clear
uv sync --locked
uv run pre-commit install

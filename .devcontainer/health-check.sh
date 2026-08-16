#!/usr/bin/env bash
set -euo pipefail

echo "==> Checking required development CLIs are installed and callable"
command -v npx
command -v gh
command -v copilot
command -v devcontainer
command -v git
command -v uv
npx --version
gh --version
copilot --version
devcontainer --version
git --version
uv --version

echo "==> Checking uv, its venv, Python version, and dependencies match .python-version / uv.lock"
# postStartCommand is invoked from workspaceFolder by the devcontainer runtime.
if uv sync --check --locked >/tmp/uv-health-check.log 2>&1; then
  echo "[devcontainer] uv health check: Python, venv, and dependencies match .python-version and uv.lock."
else
  echo
  echo "=================== DEVCONTAINER HEALTH CHECK WARNING ==================="
  echo "uv detected drift between the environment and the pinned .python-version /"
  echo "locked uv.lock (Python version, venv, or dependencies). Details:"
  echo
  cat /tmp/uv-health-check.log
  echo
  echo "Run 'uv sync --locked' (and 'uv python install' if needed) to fix this,"
  echo "The devcontainer health check cannot pass until the environment is fixed."
  echo "=========================================================================="
  echo
  exit 1
fi

echo "[devcontainer] health check passed: required CLIs and locked Python environment are available."

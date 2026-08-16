#!/usr/bin/env bash
# Build the devcontainer image and let its postStartCommand run the health check.
# Requires Docker and either a host-installed Dev Container CLI or npx.
set -euo pipefail

WORKSPACE_FOLDER="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v devcontainer >/dev/null 2>&1; then
	DEVCONTAINER_CLI=(devcontainer)
elif command -v npx.cmd >/dev/null 2>&1; then
	DEVCONTAINER_CLI=(npx.cmd --yes @devcontainers/cli)
elif command -v npx >/dev/null 2>&1; then
	DEVCONTAINER_CLI=(npx --yes @devcontainers/cli)
else
	echo "Dev Container CLI is required on the host (install it or make npx available)." >&2
	exit 1
fi

echo "==> Building and starting the devcontainer (runs postCreateCommand and health-check.sh)"
"${DEVCONTAINER_CLI[@]}" up --workspace-folder "$WORKSPACE_FOLDER" --remove-existing-container

echo "==> Devcontainer build, startup, and health checks passed."

# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:resolute

ARG USERNAME=vscode

# Fail fast if the expected user or its home directory ownership are missing.
RUN id "${USERNAME}" \
    && [ "$(stat -c '%U' "/home/${USERNAME}")" = "${USERNAME}" ]

USER root

# Install Node.js/npm (npx), GitHub CLI, and the current npm-based CLIs.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends nodejs npm gh \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global @github/copilot @devcontainers/cli \
    && node --version \
    && npm --version \
    && npx --version \
    && gh --version \
    && copilot --version \
    && devcontainer --version

USER ${USERNAME}

# Install uv via the official recommended installer script (always latest release).
# Fail fast if either git or uv are missing
RUN git --version && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    uv --version

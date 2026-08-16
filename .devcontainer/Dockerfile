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
    && npm install --global @github/copilot@1.0.80 @devcontainers/cli@0.88.0 \
    && node --version \
    && npm --version \
    && npx --version \
    && gh --version \
    && copilot --version \
    && devcontainer --version

USER ${USERNAME}

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# Install uv at the pinned version and put it on PATH for subsequent commands.
# Fail fast if either git or uv are missing
RUN git --version && \
    curl -LsSf https://astral.sh/uv/0.12.5/install.sh | sh && \
    uv --version

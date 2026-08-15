---
name: Configure VS Code Workspace
description: Configure or review this repository's VS Code workspace settings, extensions, tasks, launch configurations, Python interpreter, notebook kernel, and editor-integrated tooling.
argument-hint: Describe the VS Code workflow you want to configure, including settings, extensions, tasks, launchers, notebooks, tests, or debugging.
agent: agent
---

# Configure VS Code Workspace

Configure the VS Code workspace to satisfy the following request:

$ARGUMENTS

## Inputs

Treat the request above as the primary input. Before editing, inspect these files when they exist:

- `.vscode/settings.json`
- `.vscode/extensions.json`
- `.vscode/tasks.json`
- `.vscode/launch.json`
- `.devcontainer/devcontainer.json`
- `.python-version`
- `pyproject.toml`
- `uv.lock`
- `.github/copilot-instructions.md`
- `AGENTS.md`
- `.github/instructions/python.instructions.md`

Infer the required configuration from the request and the existing project conventions. If the request is ambiguous, identify the smallest reasonable assumption and state it before editing.

## Constraints

- Keep changes limited to `.vscode/` unless another file is required to make the requested VS Code workflow work.
- Preserve unrelated user changes and existing settings that do not conflict with the request.
- Use the Python version pinned in the root `.python-version` file; do not hardcode a different version in VS Code settings.
- Use the repository's existing uv-managed environment and interpreter rather than introducing another environment manager.
- Keep Python, Ruff, ty, pytest, Jupyter, and Interactive Window settings consistent with `pyproject.toml` and the devcontainer.
- Do not duplicate devcontainer-only extension configuration in workspace files unless the workflow requires both local and container use.
- Prefer stable workspace-relative paths and commands over machine-specific absolute paths.
- Do not add extensions, tasks, launchers, or settings without a clear connection to the requested workflow.
- Do not change application code, notebooks, dependencies, devcontainer configuration, CI, or customization files unless the request explicitly requires it.
- Do not add secrets, credentials, account identifiers, or personal financial data to VS Code configuration.

## Workflow

1. Inspect the current VS Code and project configuration.
1. Identify which VS Code file owns the requested behavior.
1. Check related contracts: interpreter paths, notebook kernels, uv commands, task dependencies, debug targets, extension IDs, and devcontainer behavior.
1. Make the smallest incremental edit that satisfies the request.
1. Validate the changed JSON and any referenced commands or paths.
1. Check that the configuration supports both the local workspace and the devcontainer when both are relevant.
1. Review the diff for unrelated changes and configuration that is specific to one machine.

## Outputs

Return a concise report with these sections:

### Configuration Summary

Describe the requested workflow and how the VS Code configuration now supports it.

### Changed Files

List every changed, added, or removed file and summarize its role.

### Settings and Integrations

List relevant interpreter, kernel, extension, formatter, linter, type-checker, test, task, launch, and devcontainer integrations.

### Validation

List each validation command or check performed and its result. Include JSON parsing, referenced-path checks, and any focused project checks.

### Assumptions and Limitations

State assumptions, unavailable checks, Docker or network limitations, and any follow-up needed from the user.

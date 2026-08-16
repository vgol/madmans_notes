# Project Baseline

- Read [AGENTS.md](../AGENTS.md) first for specialist routing, delegation rules, and the distinction between instructions, skills, prompts, and custom agents.
- Treat this repository as a Python and uv workspace for family-finance analysis, notebooks, experiments, and VS Code's Interactive Window. Use the root `.python-version` file as the source of truth for the Python version.
- Preserve unrelated user changes and keep edits focused.
- Do not turn the project into a distributable package unless explicitly requested.
- Protect financial and personal data; do not commit credentials, bank exports, account identifiers, or unnecessary raw private data.
- Use the narrowest relevant validation and report checks that could not run.

## Area-Specific Guidance

- For Python and notebook files, apply [Python and Notebook Guidelines](./instructions/python.instructions.md).
- For GitHub Actions workflows and pre-commit configuration, apply [CI Workflow Guidelines](./instructions/ci.instructions.md).
- For specialist ownership and delegation, follow the agents linked from [AGENTS.md](../AGENTS.md).
- For repeatable workflows, use the relevant skill in [`.github/skills/`](./skills/).
- For focused user-invoked operations, use the relevant prompt in [`.github/prompts/`](./prompts/).

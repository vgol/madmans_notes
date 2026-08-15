# Agent Routing

This repository is a Python and uv workspace for family-finance analysis, notebooks, experiments, etc... The supported Python version is pinned in the root `.python-version` file. The coordinating agent should use the routing rules below to select a specialist and should retain responsibility for final integration and the user-facing response.

## Routing Rules

- Route family-finance questions, budgeting, cash-flow analysis, spending categorization, pandas, matplotlib, Dash, data quality, financial visualizations, and notebook-based financial exploration to `Data Finance Analyst` in `.github/agents/data-finance-analyst.agent.md`.
- Route Python implementation, reusable helpers, typing, pytest tests, Ruff fixes, ty issues, and uv-managed Python changes to `Python Developer` in `.github/agents/python-developer.agent.md`.
- Route devcontainers, `.vscode/` configuration, GitHub Actions, CI/CD, pre-commit hooks, quality gates, repository automation, and development tooling to `Development Infrastructure Engineer` in `.github/agents/development-infra-engineer.md`.
- Route `AGENTS.md`, `copilot-instructions.md`, `*.instructions.md`, `*.agent.md`, `*.prompt.md`, `SKILL.md`, routing, handoffs, tool restrictions, and customization discovery issues to `Agent Customization Specialist` in `.github/agents/agents-customization-engineer.agent.md`.

## Delegation Protocol

- Choose the narrowest specialist that owns the behavior rather than delegating by file extension alone.
- Before delegating, identify the task owner, the requested outcome, and the smallest self-contained implementation slice.
- Give a delegated agent a structured task packet containing: goal, relevant files, current behavior, constraints, inputs and outputs, acceptance criteria, required validation, privacy constraints, and any assumptions.
- Tell the receiving agent what it must return: changed files, implementation summary, validation results, unresolved issues, and assumptions.
- Do not delegate an ambiguous investigation when a nearby read or test can resolve it first.
- `Data Finance Analyst` may delegate implementation-heavy Python work to `Python Developer`, but retains ownership of the analytical question, assumptions, data quality, privacy, and conclusions.
- `Python Developer`, `Development Infrastructure Engineer`, and `Agent Customization Specialist` are leaf specialists and should not delegate further.
- Do not create circular handoffs. An agent must not delegate a task back to its caller without new information or a changed scope.
- The coordinating agent owns cross-domain changes, conflict resolution, final validation, and the final report.

### Handoff Lifecycle

1. The sending agent states why the receiving specialist owns the next slice.
2. The sending agent provides the task packet and names the validation that could disprove the approach.
3. The receiving agent edits only within the agreed scope, unless it reports a necessary scope change first.
4. The receiving agent runs focused validation and returns the required report.
5. The sending or coordinating agent reviews the result against the original acceptance criteria and performs cross-domain validation.

### Current Handoff

- `Data Finance Analyst` can hand implementation-heavy Python, reusable helper, typing, and test slices to `Python Developer`.
- The analyst must retain the financial definitions, data-quality decisions, privacy review, assumptions, and interpretation of results.
- `Python Developer` must return implementation details and validation results; it must not make unreviewed financial conclusions.

## Instructions and Skills

- Apply `.github/instructions/python.instructions.md` to Python and notebook files. It defines the `.python-version`-based Python, uv, code, dependency, and notebook conventions.
- Use an instruction file for persistent conventions that apply to a file type or area.
- Use a skill under `.github/skills/` for a repeatable multi-step workflow with scripts, templates, or references.
- Use a prompt under `.github/prompts/` for a focused user-invoked operation with arguments.
- Use a custom agent under `.github/agents/` when the work needs a distinct role, tool boundary, or delegation policy.
- Do not duplicate the full body of an instruction, skill, or agent in this routing file; link to the owning file and keep the dispatch rule here.

## Shared Constraints

- Preserve unrelated user changes and keep edits focused.
- Do not turn the project into a distributable package unless explicitly requested.
- Use uv and the Python version pinned in `.python-version`; do not introduce another environment manager.
- Protect financial and personal data. Never commit credentials, bank exports, account identifiers, or unnecessary raw private data.
- Run the narrowest relevant validation and report checks that could not run.

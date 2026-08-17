# Roadmap

## Goal

Build a private, reproducible workflow that turns statements from multiple family bank accounts into normalized data
for exploration in Jupyter notebooks.

## Data pipeline

1. Import CSV and PDF statements from a private Google Drive location.
1. Parse each supported bank format while preserving immutable source files outside version control.
1. Convert records into a common transaction model with account aliases, dates, signed amounts, currencies,
   descriptions, source hashes, and transformation metadata.
1. Apply deterministic mutators for cleanup, merchant normalization, transfer matching, deduplication, and
   rule-based categorization.
1. Validate totals, statement overlaps, missing periods, currencies, and opening/closing balance reconciliation.
1. Export normalized JSON or JSONL for notebook analysis.

## Notebook analysis

- Monthly income, spending, transfers, fees, and net cash flow.
- Per-account and combined balances over time.
- Editable spending categories, trends, rolling averages, and budget-versus-actual reports.
- Recurring payment and subscription detection, including price changes or missed and duplicate charges.
- Merchant concentration, unusual transactions, seasonal expenses, cash-flow volatility, and minimum balances.
- Data coverage and quality reports for missing statements, uncategorized transactions, and reconciliation gaps.

## LLM-assisted analysis

- Suggest categories and normalized merchant names for ambiguous descriptions.
- Explain possible recurring-payment matches and highlight anomalies for review.
- Draft plain-language monthly summaries from aggregated, redacted data.
- Suggest additional questions to explore in notebooks.

Arithmetic, reconciliation, deduplication, and final totals will remain deterministic. LLM output will be treated as
a suggestion requiring review, not as an accounting result.

## Privacy and data quality

- Keep statements, credentials, account identifiers, and other private data out of version control.
- Prefer local processing and use aliases, redacted descriptions, and synthetic test data.
- Never send raw statements or unredacted transaction data to external models.
- Preserve source hashes and transformation history so results are traceable and reproducible.
- Surface missing data, extraction errors, uncertain matches, and multi-currency limitations instead of silently
  guessing.

## Open decisions

- Initial banks and statement layouts to support.
- JSON versus JSONL as the canonical normalized format.
- Local or external LLM execution and the required redaction policy.
- Rules for currencies, fiscal months, shared accounts, and transfer matching.

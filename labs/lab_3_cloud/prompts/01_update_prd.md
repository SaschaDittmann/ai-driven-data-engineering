# Prompt: Update the PRD with Cloud Requirements

Copy the prompt below into your AI coding assistant.

~~~
The project requirements have changed. We need to deploy this data platform to Google Cloud.

Read the existing PRD in docs/prds/ and update it with a new feature section for cloud deployment. Do not create a separate PRD — extend the existing one.

NEW REQUIREMENTS

Feature 3 — Cloud Deployment (GCP)

- Infrastructure as Code: Use Terraform to provision all GCP resources
- Data Warehouse: Google BigQuery as the production destination
- Staging Storage: Google Cloud Storage (GCS) bucket for dlt pipeline staging
- Dual-destination support: The pipeline should support both DuckDB (dev) and BigQuery (prod) via environment variables

TERRAFORM SCOPE

The Terraform configuration should create:
1. A BigQuery dataset (e.g., pokedex_raw, pokedex_staging, pokedex_marts)
2. A GCS bucket for dlt staging files
3. Necessary IAM bindings (if applicable)

PIPELINE CHANGES

- dlt: Support BigQuery as an alternative destination (controlled by env var)
- dbt: Add a "prod" target in profiles.yml using the dbt-bigquery adapter
- Tests: Ensure existing end-to-end tests still pass against DuckDB (dev)

NON-GOALS

- Orchestration (Airflow) — separate feature
- CI/CD pipeline — out of scope for now
- Multi-environment (dev/staging/prod) — single prod deployment for now
~~~

## After the AI Responds

Confirm the PRD now has a clear "Cloud Deployment" feature section that a developer (or AI) could implement from.

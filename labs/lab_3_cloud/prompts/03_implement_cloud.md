# Prompt: Implement Cloud Infrastructure & Pipeline Adaptation

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the cloud deployment tasks in docs/tasks/ and implement them. This covers three areas:

1. TERRAFORM INFRASTRUCTURE

Create Terraform configurations in infra/ that provision:

infra/
├── main.tf              # Provider config, backend
├── variables.tf         # Input variables (project_id, region, etc.)
├── bigquery.tf          # BigQuery datasets
├── storage.tf           # GCS bucket for dlt staging
├── outputs.tf           # Output values (dataset names, bucket URL)
└── terraform.tfvars     # Variable values (gitignored)

Requirements:
- Google Cloud provider
- BigQuery datasets: pokedex_raw, pokedex_staging, pokedex_marts
- GCS bucket for dlt staging files
- Use variables for project_id and region (don't hardcode)
- Add a terraform.tfvars.example with placeholder values

2. DLT PIPELINE ADAPTATION

Update the dlt pipeline to support both DuckDB and BigQuery:
- Use an environment variable (e.g., PIPELINE_DESTINATION) to switch between duckdb and bigquery
- Default to duckdb when no env var is set (local development)
- For BigQuery: use Application Default Credentials (gcloud auth application-default login)
- The BigQuery dataset should match the Terraform-created dataset

3. DBT PROFILE ADAPTATION

Update dbt to support BigQuery as a target:
- Add a "prod" target in profiles.yml using dbt-bigquery
- Keep the existing "dev" target (DuckDB) as the default
- "dbt build" should still work locally with DuckDB
- "dbt build --target prod" should target BigQuery
~~~

## While the AI Works

Verify:
- Terraform files use variables, not hardcoded project IDs
- The dlt pipeline still works locally (DuckDB) without setting env vars
- dbt's `dev` target is unchanged

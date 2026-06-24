# Prompt: Create Tasks for Cloud Migration

Copy the prompt below into your AI coding assistant.

~~~
Use skill: create-tasks

Break down the cloud deployment feature from the updated PRD in docs/prds/ into implementation tasks.

Focus on three areas:
1. Terraform infrastructure — create GCP resources (BigQuery datasets, GCS bucket)
2. Pipeline adaptation — update dlt and dbt to support BigQuery as a destination
3. Testing — verify the pipeline works end-to-end on GCP

Each parent task should be a complete vertical slice. Keep the existing ingestion and transformation tasks — add the cloud tasks as new entries.
~~~

## After the AI Responds

**When the AI presents the high-level parent tasks**, check:
- Is there a clear task for Terraform?
- Is there a task for dlt adaptation (DuckDB → BigQuery)?
- Is there a task for dbt adaptation (dbt-duckdb → dbt-bigquery)?
- Is there a testing/validation task?

Type **"Go"** when ready for the detailed sub-tasks.

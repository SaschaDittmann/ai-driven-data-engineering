# Prompt: Create PRD for Pipeline Orchestration

Copy the prompt below into your AI coding assistant.

~~~
Act as a Senior Data Engineer. Create a Product Requirements Document (PRD) for pipeline orchestration.

Use skill: create-prd

FEATURE SCOPE

Add pipeline orchestration using Apache Airflow to schedule and automate the existing dlt + dbt data pipeline.

REQUIREMENTS

- DAG structure: A single DAG that runs ingestion (dlt) followed by transformation (dbt)
- Schedule: Daily, configurable via Airflow variables
- Tasks:
  1. Run ingestion/pipeline.py (dlt → BigQuery)
  2. Run dbt build --target prod (dbt transformations)
- Error handling: Retry failed tasks up to 3 times with exponential backoff
- Alerting: Email notification on failure (configurable)
- Location: DAG files in dags/ directory

TECHNICAL CONSTRAINTS

- Use Airflow 2.x TaskFlow API or classic operators
- The DAG should work on both local Airflow and Google Cloud Composer
- Use BashOperator or PythonOperator for task execution
- No hardcoded paths or credentials — use Airflow Variables and Connections
~~~

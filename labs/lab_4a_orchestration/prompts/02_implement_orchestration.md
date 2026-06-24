# Prompt: Implement the Airflow DAG

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the orchestration tasks in docs/tasks/ and implement the Airflow DAG.

KEY REQUIREMENTS

- Location: dags/pokedex_pipeline.py
- DAG ID: pokedex_data_pipeline
- Schedule: @daily (configurable)
- Tasks in order:
  1. run_ingestion — Execute the dlt pipeline (ingestion/pipeline.py)
  2. run_dbt_build — Execute dbt build --target prod in the transform/ directory
- Dependencies: run_ingestion >> run_dbt_build

IMPLEMENTATION NOTES

- Use BashOperator for both tasks (simple, portable)
- Add retries=3 and retry_delay=timedelta(minutes=5) as defaults
- Set catchup=False to avoid backfilling
- Add DAG documentation (doc_md) explaining what the pipeline does
- Use Airflow Variables for configurable parameters (BigQuery project, dataset names)

TESTING

- Create a test that validates the DAG can be parsed without errors
- Verify task dependencies are correct
~~~

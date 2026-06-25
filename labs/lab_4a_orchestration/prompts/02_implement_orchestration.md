# Prompt: Implement Orchestration with Managed Service for Apache Airflow

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the orchestration tasks in docs/tasks/ and implement the full end-to-end pipeline orchestration with Managed Service for Apache Airflow deployment.

1. AIRFLOW DAG

Location: dags/pokedex_pipeline.py
DAG ID: pokedex_data_pipeline
Schedule: @daily (configurable via Airflow Variable)

Tasks in order:
1. run_ingestion — Execute the dlt pipeline (ingestion/pipeline.py) targeting BigQuery
2. dbt_deps — Run dbt deps to install packages
3. dbt_build — Run dbt build --target prod in the transform/ directory
4. dbt_docs — Run dbt docs generate

Dependencies: run_ingestion >> dbt_deps >> dbt_build >> dbt_docs

Implementation notes:
- Use BashOperator for all tasks (simple, portable)
- Add retries=3 and retry_delay=timedelta(minutes=5) as defaults
- Set catchup=False
- Use Airflow Variables for configurable parameters (project_id, dataset names, pipeline destination)
- Add DAG documentation (doc_md) explaining what the pipeline does
- No hardcoded credentials — use Airflow Variables and environment

2. TERRAFORM FOR MANAGED AIRFLOW

Extend the existing infra/ directory:

infra/
├── ... (existing BigQuery, GCS files)
├── apis.tf              # Enable required GCP APIs (composer, compute, container, etc.)
├── composer_network.tf  # Dedicated VPC network and subnet for Composer
├── composer_iam.tf      # Composer Service Agent IAM binding
├── composer.tf          # Composer environment + DAG/dbt deployment + variables

GCP APIs (apis.tf):
- Enable: composer, compute, container, monitoring, logging, cloudresourcemanager
- Use google_project_service with disable_on_destroy = false

Networking (composer_network.tf):
- Create a VPC network (google_compute_network) for Composer
- Create a subnet (google_compute_subnetwork) with secondary IP ranges for GKE pods/services

IAM (composer_iam.tf):
- Grant roles/composer.ServiceAgentV2Ext to the Composer Service Agent
- Use data.google_project to look up the project number

Environment (composer.tf):
- Managed Service for Apache Airflow with image_version "composer-2-airflow-2"
- ENVIRONMENT_SIZE_SMALL
- node_config with explicit service_account and the VPC network/subnet
- pypi_packages: dbt-core, dbt-bigquery, dlt[bigquery], requests, google-cloud-storage
- depends_on: APIs, IAM, and networking must be created first
- Upload DAG files from dags/ to the Airflow GCS bucket using google_storage_bucket_object
- Upload dbt project and ingestion scripts to dags/ subdirectories
- Create a variables.json with project config and upload to Airflow GCS data/ folder
- Import variables via a local-exec provisioner: gcloud composer environments run ... variables import

3. TESTING

- Create a test that validates the DAG can be parsed by Airflow without errors
- Verify task dependencies are in the correct order
- Test that variables.json contains all required keys
~~~

## While the AI Works

Observe how it handles:
- Structuring the Terraform for the Airflow environment (VPC, service accounts, IAM)
- Configuring `pypi_packages` for the Airflow environment
- DAG deployment via GCS bucket objects
- Airflow Variable management

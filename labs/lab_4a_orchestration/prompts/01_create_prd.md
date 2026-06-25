# Prompt: Create PRD for Pipeline Orchestration

Copy the prompt below into your AI coding assistant.

~~~
Act as a Senior Data Engineer. Create a Product Requirements Document (PRD) for pipeline orchestration.

Use skill: create-prd

Important: The scope below is already well-defined. Only ask clarifying questions about areas that are genuinely ambiguous or missing. If everything is clear, proceed directly to generating the PRD.

FEATURE SCOPE

Add end-to-end pipeline orchestration using Apache Airflow on Managed Service for Apache Airflow (formerly Cloud Composer). The DAG should orchestrate the full data pipeline: dlt ingestion followed by dbt transformation, deployed and running in the cloud.

REQUIREMENTS

DAG Design:
- A single DAG that runs the full pipeline end-to-end
- Task 1: Run the dlt ingestion pipeline (ingestion/pipeline.py targeting BigQuery)
- Task 2: Run dbt deps to install dbt packages
- Task 3: Run dbt build --target prod (transformations + tests)
- Task 4: Run dbt docs generate for documentation
- Dependencies: ingestion >> dbt_deps >> dbt_build >> dbt_docs
- Schedule: Daily, configurable via Airflow Variables
- Error handling: Retry failed tasks up to 3 times with exponential backoff
- Set catchup=False to avoid backfilling

dbt Execution Strategy:
- Use BashOperator for all tasks (simple, portable, good for workshop scope)
- Do NOT use Cosmos (astronomer-cosmos) — it adds complexity beyond the workshop scope
- BashOperator commands: "dbt deps", "dbt build --target prod", "dbt docs generate"

GCP APIs (Terraform):
- Enable all APIs that Cloud Composer depends on before creating the environment:
  - composer.googleapis.com
  - compute.googleapis.com
  - container.googleapis.com (GKE, used internally by Composer 2)
  - monitoring.googleapis.com
  - logging.googleapis.com
  - cloudresourcemanager.googleapis.com
- Use google_project_service resources with disable_on_destroy = false

Networking (Terraform):
- Create a dedicated VPC network and subnet for the Composer environment
- The subnet needs a secondary IP range for GKE pods and services (Composer 2 runs on GKE internally)
- Reference this VPC/subnet in the Composer environment's node_config

Managed Service for Apache Airflow Infrastructure (Terraform):
- Provision a Managed Service for Apache Airflow environment using Terraform (extend existing infra/ directory)
- Use ENVIRONMENT_SIZE_SMALL for the workshop
- Use the default Compute Engine service account — specify it explicitly in node_config as {project-number}-compute@developer.gserviceaccount.com
- Grant the Composer Service Agent the roles/composer.ServiceAgentV2Ext role
- Include pypi_packages for dbt-core, dbt-bigquery, dlt[bigquery], requests, and google-cloud-storage
- Set depends_on to ensure APIs, IAM bindings, and networking are created before the Composer environment
- Deploy DAG files to the Airflow GCS bucket via Terraform using google_storage_bucket_object
- Configure Airflow Variables via a variables.json uploaded to GCS data/ folder
- Import variables via gcloud composer environments run ... variables import (as a Terraform local-exec provisioner)

DAG Deployment:
- DAG files in dags/ directory
- The dbt project files (models, macros, profiles.yml) should be bundled alongside the DAG in the GCS bucket — do NOT clone from Git at runtime
- Terraform uploads both DAGs and dbt project files to the Airflow environment's GCS bucket

Airflow Variables (variables.json):
- gcp_project_id: The GCP project ID
- gcp_location: The BigQuery/GCS region
- gcs_bucket_name: The dlt staging bucket name
- pokemon_limit: Number of Pokemon to ingest (default: 151)
- pipeline_destination: Set to "bigquery"

Testing:
- Create a pytest test that validates the DAG file can be parsed without import errors
- Verify task dependencies are in the correct order
- No need for full end-to-end Airflow testing in the workshop — manual trigger and monitoring is sufficient

TECHNICAL CONSTRAINTS

- Use Airflow 2.x with Managed Service for Apache Airflow (composer-2-airflow-2 image)
- No hardcoded paths, project IDs, or credentials — use Airflow Variables
- The default Compute Engine service account must have BigQuery Editor and GCS permissions (these are typically granted by default in the workshop playground)
~~~

# Lab 4a — Orchestrate It: End-to-End Pipeline on Managed Service for Apache Airflow

*Optional lab — for faster groups, extended workshops, or take-home exercise.*

In this lab you'll orchestrate the full data pipeline (dlt ingestion → dbt transformation) as an Airflow DAG and deploy it to **Managed Service for Apache Airflow** (formerly Cloud Composer). This goes beyond just writing a DAG — you'll provision the Airflow environment with Terraform, deploy DAGs, and run the pipeline end-to-end in the cloud.

## Learning Objectives

- Use the full AI workflow cycle (PRD → tasks → implement → learn → finalize) for orchestration
- Build an Airflow DAG that chains dlt ingestion and dbt transformation
- Provision a Managed Service for Apache Airflow environment using Terraform
- Deploy DAGs and Airflow Variables to Managed Service for Apache Airflow
- Run and monitor the pipeline in a managed Airflow environment

## Tools

| | |
|---|---|
| **Tool type** | CLI or IDE (your choice) |
| **Environment** | GCP (Managed Service for Apache Airflow) |
| **Duration** | 60–75 minutes |

## Prerequisites

- Lab 3 completed (pipeline running on BigQuery, Terraform infra in place)
- GCP Playground with Managed Service for Apache Airflow API enabled
- `gcloud` CLI authenticated

## Steps

### Step 1 — Create a PRD for Orchestration (10 min)

1. Copy the prompt from [`prompts/01_create_prd.md`](prompts/01_create_prd.md) into your AI assistant
2. Answer clarifying questions based on the prompt guidance
3. Review the generated PRD

### Step 2 — Create Tasks and Implement (40–50 min)

1. Use `create-tasks` to generate task breakdowns
2. Create a feature branch with `git-worktree`
3. Use `implement-tasks` with the prompt from [`prompts/02_implement_orchestration.md`](prompts/02_implement_orchestration.md)
4. The AI should create:
   - **Terraform** for a Managed Service for Apache Airflow environment (extending `infra/`)
   - **Airflow DAG** that orchestrates the full pipeline
   - **Airflow Variables** configuration for deployment
   - **DAG deployment** mechanism (upload to Airflow's GCS bucket)

### Step 3 — Deploy to Managed Service for Apache Airflow (10 min)

1. Apply the Terraform to provision the Airflow environment:
   ```bash
   cd infra
   terraform plan
   terraform apply
   ```
   Note: Environment provisioning takes 15–25 minutes. The instructor may have pre-provisioned environments.
2. Deploy DAGs to the Airflow GCS bucket
3. Import Airflow Variables

### Step 4 — Run and Monitor (5–10 min)

1. Open the Airflow UI (link from GCP console or `terraform output`)
2. Trigger the DAG manually
3. Monitor task execution — watch ingestion complete, then transformation start
4. Verify data in BigQuery after the run completes

### Step 5 — Document and Finalize (5 min)

1. Document what you learned:
   ```
   Use skill: document-learnings
   ```
2. Use `finalize-tasks` to create a PR

## Checkpoints

- [ ] PRD for orchestration feature exists
- [ ] Terraform config for Managed Service for Apache Airflow environment in `infra/`
- [ ] Airflow DAG file created in `dags/`
- [ ] DAG chains ingestion (dlt) → transformation (dbt) in correct order
- [ ] DAG uses Airflow Variables for configuration (no hardcoded values)
- [ ] DAGs deployed to Managed Service for Apache Airflow's GCS bucket
- [ ] DAG runs successfully in Managed Service for Apache Airflow
- [ ] Data appears in BigQuery after DAG run
- [ ] Feature branch merged into `development`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Environment provisioning takes too long | It can take 15–25 min. Ask the instructor if pre-provisioned environments are available |
| DAG import errors in Airflow | Check the Airflow logs — common issues are missing Python packages (add them to `pypi_packages` in Terraform) |
| dbt fails in Airflow | Ensure `dbt-core` and `dbt-bigquery` are in the environment's `pypi_packages`. Check the BigQuery connection config |
| Permission denied | Verify the Airflow service account has BigQuery and GCS permissions |

## Next

Try another optional lab:
- [Lab 4b — Visualize It](../lab_4b_visualization/README.md)
- [Lab 4c — AI/ML on It](../lab_4c_ai_ml/README.md)

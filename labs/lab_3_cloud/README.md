# Lab 3 — Ship It: Go to Cloud

Requirements change — just like in the real world. In this lab, the project needs to move from local DuckDB to **Google BigQuery on GCP**. You'll update the PRD with new cloud requirements, generate new tasks, then have AI produce Terraform files and adapt the pipeline.

This lab demonstrates two things: AI handles Infrastructure-as-Code just as well as application code, and your context engineering workflow scales to evolving requirements.

## Learning Objectives

- Update an existing PRD when requirements change (re-planning with AI)
- Use AI to generate Terraform (HCL) for GCP infrastructure
- Adapt an existing dlt + dbt pipeline from DuckDB to BigQuery
- Experience the full cycle: update PRD → create tasks → implement → finalize

## Tools

| | |
|---|---|
| **Tool type** | Your choice — CLI or IDE (you've used both, pick what works for you) |
| **Environment** | Local + GCP Playground |
| **Duration** | 60–75 minutes |

## Prerequisites

- Labs 0–2 completed (working local pipeline with dlt + dbt)
- GCP Playground project access provided by the instructor
- Terraform installed (1.0+)
- `gcloud` CLI authenticated to the playground project

## Steps

### Step 1 — Update the PRD (10 min)

Requirements have changed. Use the prompt from [`prompts/01_update_prd.md`](prompts/01_update_prd.md) to update the existing PRD with cloud requirements.

1. Copy the prompt into your AI assistant
2. The AI will read the existing PRD and add cloud-specific requirements
3. Review the updated PRD — does it now cover Terraform, BigQuery, and GCS?

### Step 2 — Create New Tasks (10 min)

Use the prompt from [`prompts/02_create_tasks.md`](prompts/02_create_tasks.md) to generate tasks for the cloud migration.

1. Copy the prompt into your AI assistant
2. Review the generated tasks — they should cover infrastructure, pipeline adaptation, and testing
3. Type **"Go"** to generate detailed sub-tasks

### Step 3 — Implement Cloud Infrastructure & Pipeline Adaptation (30 min)

Use the prompt from [`prompts/03_implement_cloud.md`](prompts/03_implement_cloud.md) to have AI create Terraform files and adapt the pipeline for BigQuery.

1. Copy the prompt into your AI assistant
2. The AI will implement all three areas in one go:
   - **Terraform** in `infra/` (BigQuery datasets, GCS bucket)
   - **dlt adaptation** (dual-destination support via `PIPELINE_DESTINATION` env var)
   - **dbt adaptation** (`prod` target in `profiles.yml` using `dbt-bigquery`, SQL dialect fixes)
3. Review the generated code before applying

### Step 4 — Deploy to GCP (10 min)

1. Configure Terraform variables — copy the example file and fill in your GCP project details:
   ```bash
   cd infra
   cp terraform.tfvars.example terraform.auto.tfvars
   ```
   Edit `terraform.auto.tfvars` and set the correct values:
   ```hcl
   project_id  = "your-gcp-project-id"       # from the GCP Playground
   region      = "us-central1"                # or your preferred region
   bucket_name = "your-unique-dlt-staging-bucket"  # must be globally unique
   ```
2. Apply the Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
3. Set the environment variables from the Terraform outputs:
   ```bash
   export PIPELINE_DESTINATION=bigquery
   export GCS_BUCKET_URL=$(terraform output -raw dlt_staging_bucket_url)
   export GCP_PROJECT=$(terraform output -raw project_id)
   export GCP_LOCATION=$(terraform output -raw region)
   ```
4. Run the dlt pipeline targeting BigQuery:
   ```bash
   cd ..
   uv run python ingestion/pipeline.py
   ```
5. Run dbt against BigQuery:
   ```bash
   cd transform
   dbt build --target prod
   ```
6. Verify data in BigQuery — ask the AI to help you query it

### Step 5 — Document Learnings (5 min)

Capture what you learned during this lab.

1. Tell your AI assistant what you learned or what surprised you:
   ```
   Use skill: document-learnings
   ```
2. The AI will create a file in `docs/learnings/` with the key takeaway

### Step 6 — Finalize (5 min)

1. Use `finalize-tasks` to clean up and create a PR
2. Review the PR — it should include Terraform files, pipeline changes, and updated dbt config

## Checkpoints

- [ ] PRD updated with cloud migration requirements
- [ ] New task file generated for cloud work
- [ ] Terraform files exist in `infra/` directory
- [ ] Terraform applied successfully to GCP Playground
- [ ] BigQuery dataset created
- [ ] GCS bucket created (for dlt staging)
- [ ] dlt pipeline runs and loads data into BigQuery
- [ ] dbt models run against BigQuery (`dbt build --target prod`)
- [ ] Pipeline supports both DuckDB (dev) and BigQuery (prod) destinations
- [ ] PR created via `finalize-tasks`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Terraform auth fails | Run `gcloud auth application-default login` and set your project: `gcloud config set project <PROJECT_ID>` |
| Terraform plan shows errors | Check that the GCP APIs are enabled (BigQuery, Cloud Storage). Ask the instructor if the playground is set up correctly |
| dlt can't connect to BigQuery | Verify credentials — `dlt` can use Application Default Credentials. Check `gcloud auth application-default print-access-token` works |
| dbt BigQuery dialect errors | Some DuckDB SQL syntax differs from BigQuery (e.g., `::` casting). Ask the AI to fix dialect-specific issues |
| Permission denied on GCP | Ask the instructor to verify your playground access — you need BigQuery Editor and Storage Admin roles |
| Pipeline takes several minutes | Loading to BigQuery via GCS staging is slower than local DuckDB (~4 min for 151 Pokemon). Be patient and don't Ctrl+C |
| "pending load packages" warning | If you interrupted a previous run, dlt resumes from where it stopped. Let it finish, then run again for fresh data |
| `google-cloud-bigquery-storage` warning | Run `uv pip install google-cloud-bigquery-storage` — it's needed for optimized BigQuery reads |

## Falling Behind?

If you didn't complete previous labs or want to start fresh with the reference solutions:

```bash
# macOS/Linux
bash labs/lab_3_cloud/prepare.sh ~/my-pokedex-project

# Windows (PowerShell)
.\labs\lab_3_cloud\prepare.ps1 -ProjectDir ~\my-pokedex-project
```

This copies Lab 0 + Lab 1 + Lab 2 reference solutions into your project and runs the ingestion pipeline if needed.

## Next

You've completed the core workshop! If time allows, continue with one of the optional labs:
- [Lab 4a — Orchestrate It](../lab_4a_orchestration/README.md) — Schedule the pipeline with Airflow
- [Lab 4b — Visualize It](../lab_4b_visualization/README.md) — Build a Streamlit dashboard
- [Lab 4c — AI/ML on It](../lab_4c_ai_ml/README.md) — Train BQML models and use Gemini on your data

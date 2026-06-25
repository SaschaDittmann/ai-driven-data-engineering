# Implementation Tasks: Competitive Pokemon Analytics

This document breaks down the Product Requirements Document (PRD) into vertical slices. Each parent task is designed to be a complete, independently testable, and shippable unit of work.

## Relevant Files

- `ingestion/pokemon_pipeline.py` - Core dlt ingestion pipeline script
- `tests/test_pipeline.py` - Integration and unit tests for the ingestion pipeline
- `transform/dbt_project.yml` - dbt project configuration
- `transform/models/staging/stg_pokemon.sql` - Staging model for Pokemon data
- `transform/models/staging/stg_types.sql` - Staging model for Type lookup data
- `transform/models/staging/stg_moves.sql` - Staging model for Move lookup data
- `transform/models/staging/stg_abilities.sql` - Staging model for Ability lookup data
- `transform/models/staging/schema.yml` - Test definitions and documentation for staging layer
- `transform/models/marts/dim_type_effectiveness.sql` - Mart dimension table for type effectiveness
- `transform/models/marts/fct_pokemon_stats.sql` - Mart fact table for Pokemon base stats and type-average offsets
- `transform/models/marts/fct_competitive_moves.sql` - Mart fact table for Pokemon movepools and STAB power calculations
- `transform/models/marts/schema.yml` - Test definitions and documentation for marts layer
- `infra/main.tf` - Terraform configuration for GCP resources (BigQuery datasets, GCS bucket, IAM)
- `infra/variables.tf` - Terraform input variables (project ID, region, bucket name)
- `infra/outputs.tf` - Terraform outputs (dataset IDs, bucket URL)
- `infra/terraform.tfvars.example` - Example Terraform variable values for onboarding
- `ingestion/pipeline.py` - Modified to support dual-destination (DuckDB/BigQuery) via DESTINATION env var
- `transform/profiles.yml` - Modified to add `prod` target using dbt-bigquery adapter
- `.env.example` - Documents all environment variables for local dev and cloud deployment
- `tests/test_pipeline.py` - Extended with backward compatibility tests for dual-destination logic

### Notes

- Each parent task represents a complete vertical slice containing implementation, tests, observability/logging, and documentation.
- Tasks 1.0–5.0 cover Feature 1 (Ingestion) and Feature 2 (Transformation). Tasks 6.0–8.0 cover Feature 3 (Cloud Deployment).

---

## Tasks

- [ ] 1.0 Ingestion of Lookup Data (Types, Abilities, Moves, and Stats catalogs)
  - [ ] 1.1 Implement generator-based dlt sources and resources in `ingestion/pokemon_pipeline.py` for `/type`, `/ability`, `/move`, and `/stat` endpoints.
  - [ ] 1.2 Implement general pagination handler (following the `next` link) and a requests HTTP client with retry logic on HTTP 429 using exponential backoff.
  - [ ] 1.3 Write mock-based pytest unit tests in `tests/test_pipeline.py` using `responses` or `pytest-httpserver` to verify successful ingestion of lookup catalogs into the `raw` schema of `data/test_pokedex.db`.
  - [ ] 1.4 Add logging statements to track pagination steps, rate limit status, and total records successfully ingested.
  - [ ] 1.5 Add code docstrings and inline documentation detailing the pipeline structure, pagination helpers, and configuration settings.

- [ ] 2.0 Ingestion of Pokemon Details with limit configuration
  - [ ] 2.1 Implement generator-based dlt resource for the `/pokemon` endpoints in `ingestion/pokemon_pipeline.py`. Use `write_disposition="merge"` with `id` as the primary key.
  - [ ] 2.2 Add parsing logic for the `POKEMON_LIMIT` environment variable. If set to a number > 0, restrict the fetched Pokemon detail records to that number. Ensure this limit does not affect lookup catalog tables (types, abilities, moves, stats).
  - [ ] 2.3 Write integration tests in `tests/test_pipeline.py` using mock JSON payloads to verify that `POKEMON_LIMIT` works correctly (e.g. limiting to 5 records) and that child tables (e.g. nested stats/types arrays) are successfully loaded into `data/test_pokedex.db` via schema evolution.
  - [ ] 2.4 Add logging to output load status updates, total records loaded per batch, and dlt execution metadata (e.g. schema changes).
  - [ ] 2.5 Document details on dlt schema evolution, state management, and the `POKEMON_LIMIT` configuration inside the project readme and docstrings.

- [ ] 3.0 Staging Layer Transformation
  - [ ] 3.1 Initialize the dbt project under `transform/`, mapping the profiles to the local DuckDB database (`data/pokedex.db`), and write staging SQL files (prefix `stg_`) mapping 1:1 to the raw tables (`pokemon`, `types`, `moves`, `abilities`).
  - [ ] 3.2 Configure basic column cleanups, datatype castings (e.g. casting string IDs to integers), and renaming schema attributes in the SQL files.
  - [ ] 3.3 Write `transform/models/staging/schema.yml` to define model tests (uniqueness, non-null, and relationships constraints) and column-level descriptions.
  - [ ] 3.4 Execute `dbt build` to verify model compilation, execution, and validation checks.
  - [ ] 3.5 Document model designs and naming conventions in the transform codebase.

- [ ] 4.0 Type Effectiveness Mart Transformation
  - [ ] 4.1 Write the mart model `dim_type_effectiveness` in `transform/models/marts/dim_type_effectiveness.sql`. Pivot the raw type damage relations into a complete 18x18 type effectiveness matrix (Normal, Fire, Water, etc.).
  - [ ] 4.2 Restrict the types list strictly to the standard 18 types (excluding `unknown` and `shadow` if present).
  - [ ] 4.3 Configure dbt schema tests in `transform/models/marts/schema.yml` verifying that the table contains exactly 324 rows, unique combinations of `attacking_type` and `defending_type`, and that damage multipliers belong to `{0.0, 0.5, 1.0, 2.0}`.
  - [ ] 4.4 Run `dbt run --select dim_type_effectiveness` to verify successful transformation execution and inspect the compiled SQL.
  - [ ] 4.5 Add full descriptions for each column in the yml configuration.

- [ ] 5.0 Pokemon Stats & Competitive Moves Mart Transformations
  - [ ] 5.1 Write the fact model `fct_pokemon_stats` in `transform/models/marts/fct_pokemon_stats.sql`. Unflatten/pivot the stats array into columns (`hp`, `attack`, etc.), compute the Base Stat Total (BST), extract the primary type (where `slot = 1`), and calculate the difference of each Pokemon's stats against the average stats for its primary type.
  - [ ] 5.2 Write the fact model `fct_competitive_moves` in `transform/models/marts/fct_competitive_moves.sql`. Join Pokemon with all their learnable moves, identify STAB (`is_stab`) by comparing move type with the Pokemon's primary or secondary type, and calculate `stab_adjusted_power` (multiplying power by 1.5 if STAB is true, normal power if false, and returning NULL if the move has no base power).
  - [ ] 5.3 Configure dbt tests in `transform/models/marts/schema.yml` to validate keys, check that BST is the sum of the individual stats, check that STAB-adjusted power is correctly calculated, and verify relationship integrations.
  - [ ] 5.4 Run `dbt build` for the entire project to ensure all models compile, run, and pass their validation tests end-to-end.
  - [ ] 5.5 Document all columns, calculations, and tables in the schema markdown file.

- [ ] 6.0 Terraform Infrastructure for GCP (BigQuery Datasets, GCS Bucket, IAM)
  - [ ] 6.1 Create `infra/main.tf` with the Terraform `google` provider configuration. Define `google_bigquery_dataset` resources for `pokedex_raw`, `pokedex_staging`, and `pokedex_marts` in the configured GCP project and location.
  - [ ] 6.2 Add a `google_storage_bucket` resource for the dlt staging bucket (used for intermediate file staging during BigQuery loads). Configure lifecycle rules and uniform bucket-level access.
  - [ ] 6.3 Create `infra/variables.tf` defining input variables: `gcp_project_id` (required), `gcp_location` (default `us-central1`), `gcs_bucket_name` (required), and any optional variables for resource naming prefixes.
  - [ ] 6.4 Create `infra/outputs.tf` exposing the created resource identifiers: BigQuery dataset IDs, GCS bucket name, and GCS bucket URL for downstream pipeline configuration.
  - [ ] 6.5 Create `infra/terraform.tfvars.example` with placeholder values documenting the expected variable inputs. Add `*.tfvars` and `.terraform/` to `.gitignore`.
  - [ ] 6.6 Validate the Terraform configuration by running `terraform init` and `terraform validate` in the `infra/` directory. Fix any syntax or provider errors.
  - [ ] 6.7 Run `terraform plan` against a real GCP project to verify the execution plan creates exactly 3 BigQuery datasets and 1 GCS bucket with no errors.
  - [ ] 6.8 Document the Terraform setup in `infra/README.md`: prerequisites (GCP project, `gcloud` auth, Terraform >= 1.5), usage instructions (`init`, `plan`, `apply`), and variable descriptions.

- [ ] 7.0 Dual-Destination Pipeline Adaptation (dlt → BigQuery, dbt → prod target)
  - [ ] 7.1 Refactor `ingestion/pipeline.py` `run_pipeline()` to read the `DESTINATION` environment variable. When `DESTINATION=bigquery`, configure the dlt pipeline with `destination="bigquery"` and `staging="filesystem"` using the GCS bucket from `GCS_BUCKET_NAME`. When unset or `DESTINATION=duckdb`, preserve the existing DuckDB behavior unchanged.
  - [ ] 7.2 When `DESTINATION=bigquery`, configure dlt to use `GCP_PROJECT_ID` for the BigQuery project and `GCS_BUCKET_NAME` for the filesystem staging location. Ensure credentials are resolved via Application Default Credentials (ADC) — no service account key files.
  - [ ] 7.3 Update `transform/profiles.yml` to add a `prod` target using the `dbt-bigquery` adapter. The target must reference `GCP_PROJECT_ID` via Jinja env_var(), set `dataset` to `pokedex_raw` (for source), and configure the `location` from `GCP_LOCATION`. Keep the existing `dev` and `test` targets unchanged.
  - [ ] 7.4 Create `.env.example` at the project root documenting all environment variables: `POKEMON_LIMIT`, `DESTINATION`, `GCP_PROJECT_ID`, `GCP_LOCATION`, and `GCS_BUCKET_NAME`, with inline comments explaining defaults and valid values.
  - [ ] 7.5 Write backward compatibility tests in `tests/test_pipeline.py` that verify: (a) when `DESTINATION` is unset, the pipeline defaults to DuckDB, (b) when `DESTINATION=duckdb`, it explicitly uses DuckDB, and (c) the pipeline function signature and return value remain unchanged. Use mocking/patching of `dlt.pipeline` to verify the destination argument without requiring GCP credentials.
  - [ ] 7.6 Run the full existing test suite (`uv run pytest tests/ -v`) to confirm all pre-existing DuckDB-based tests pass without modification — zero regressions.
  - [ ] 7.7 Add logging in `run_pipeline()` to clearly report which destination is active, the GCS staging bucket (if BigQuery), and the GCP project ID at pipeline startup.
  - [ ] 7.8 Update docstrings in `ingestion/pipeline.py` and add a "Cloud Deployment" section to `README.md` documenting the dual-destination configuration, required environment variables, and how to switch between dev (DuckDB) and prod (BigQuery).

- [ ] 8.0 End-to-End Cloud Verification (BigQuery Pipeline + dbt prod)
  - [ ] 8.1 Run `terraform apply` in `infra/` against a real GCP project to provision all resources. Verify via `bq ls` and `gsutil ls` that the 3 BigQuery datasets and GCS bucket exist.
  - [ ] 8.2 Execute the dlt pipeline with `DESTINATION=bigquery`, `GCP_PROJECT_ID`, `GCS_BUCKET_NAME`, and `POKEMON_LIMIT=5` (small subset for fast verification). Confirm data lands in the `pokedex_raw` BigQuery dataset.
  - [ ] 8.3 Run `dbt build --target prod` from the `transform/` directory. Verify that all staging and marts models compile and execute against BigQuery without SQL dialect errors.
  - [ ] 8.4 Validate data parity: compare row counts for key tables (`pokemon`, `types`, `moves`, `fct_pokemon_stats`, `dim_type_effectiveness`, `fct_competitive_moves`) between the DuckDB dev output and the BigQuery prod output to confirm they match.
  - [ ] 8.5 Re-run the full DuckDB test suite (`uv run pytest tests/ -v`) one final time to confirm zero regressions after all Feature 3 code changes.
  - [ ] 8.6 Document the end-to-end cloud verification process as a runbook in `docs/runbooks/cloud-deployment.md`, including: prerequisite setup steps, the exact commands to run, expected outputs, and troubleshooting tips for common GCP auth or permission errors.

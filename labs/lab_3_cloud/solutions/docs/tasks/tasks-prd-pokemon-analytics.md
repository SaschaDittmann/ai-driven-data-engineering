# Implementation Tasks: Competitive Pokemon Analytics

This document breaks down the Product Requirements Document (PRD) into vertical slices. Each parent task is designed to be a complete, independently testable, and shippable unit of work.

## Relevant Files

- `ingestion/pokemon_pipeline.py` - Core dlt ingestion pipeline script
- `tests/test_pipeline.py` - Integration and unit tests for the ingestion pipeline
- `tests/test_transform.py` - End-to-end pytest tests for dbt transformation models
- `transform/dbt_project.yml` - dbt project configuration
- `transform/profiles.yml` - dbt-duckdb and dbt-bigquery connection profiles
- `transform/macros/generate_schema_name.sql` - Custom schema naming for staging/marts layers
- `transform/macros/standard_types.sql` - Standard 18-type list macro
- `transform/models/staging/_staging.yml` - Source definitions, staging model docs, and tests
- `transform/models/staging/stg_pokemon.sql` - Staging model for Pokemon data
- `transform/models/staging/stg_types.sql` - Staging model for Type lookup data
- `transform/models/staging/stg_moves.sql` - Staging model for Move lookup data
- `transform/models/staging/stg_abilities.sql` - Staging model for Ability lookup data
- `transform/models/staging/stg_stats.sql` - Staging model for Stat catalog data
- `transform/models/marts/_marts.yml` - Mart model docs and tests
- `transform/models/marts/dim_type_effectiveness.sql` - Mart dimension table for type effectiveness
- `transform/models/marts/fct_pokemon_stats.sql` - Mart fact table for Pokemon base stats and type-average offsets
- `transform/models/marts/fct_competitive_moves.sql` - Mart fact table for Pokemon movepools and STAB power calculations
- `transform/tests/assert_dim_type_effectiveness_row_count.sql` - Singular test for 18x18 matrix row count
- `transform/tests/assert_dim_type_effectiveness_unique_pairs.sql` - Singular test for unique type pairs
- `transform/tests/assert_bst_equals_sum_of_stats.sql` - Singular test validating BST calculation
- `transform/tests/assert_stab_adjusted_power.sql` - Singular test validating STAB power logic
- `infra/main.tf` - Core Terraform configuration for GCP resources
- `infra/variables.tf` - Terraform input variables
- `infra/outputs.tf` - Terraform output variables

### Notes

- Each parent task represents a complete vertical slice containing implementation, tests, observability/logging, and documentation.

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

- [x] 3.0 Staging Layer Transformation
  - [x] 3.1 Initialize the dbt project under `transform/`, mapping the profiles to the local DuckDB database (`data/pokedex.db`), and write staging SQL files (prefix `stg_`) mapping 1:1 to the raw tables (`pokemon`, `types`, `moves`, `abilities`).
  - [x] 3.2 Configure basic column cleanups, datatype castings (e.g. casting string IDs to integers), and renaming schema attributes in the SQL files.
  - [x] 3.3 Write `transform/models/staging/_staging.yml` to define model tests (uniqueness, non-null, and relationships constraints) and column-level descriptions.
  - [x] 3.4 Execute `dbt build` to verify model compilation, execution, and validation checks.
  - [x] 3.5 Document model designs and naming conventions in the transform codebase.

- [x] 4.0 Type Effectiveness Mart Transformation
  - [x] 4.1 Write the mart model `dim_type_effectiveness` in `transform/models/marts/dim_type_effectiveness.sql`. Pivot the raw type damage relations into a complete 18x18 type effectiveness matrix (Normal, Fire, Water, etc.).
  - [x] 4.2 Restrict the types list strictly to the standard 18 types (excluding `unknown` and `shadow` if present).
  - [x] 4.3 Configure dbt schema tests in `transform/models/marts/_marts.yml` verifying that the table contains exactly 324 rows, unique combinations of `attacking_type` and `defending_type`, and that damage multipliers belong to `{0.0, 0.5, 1.0, 2.0}`.
  - [x] 4.4 Run `dbt run --select dim_type_effectiveness` to verify successful transformation execution and inspect the compiled SQL.
  - [x] 4.5 Add full descriptions for each column in the yml configuration.

- [x] 5.0 Pokemon Stats & Competitive Moves Mart Transformations
  - [x] 5.1 Write the fact model `fct_pokemon_stats` in `transform/models/marts/fct_pokemon_stats.sql`. Unflatten/pivot the stats array into columns (`hp`, `attack`, etc.), compute the Base Stat Total (BST), extract the primary type (where `slot = 1`), and calculate the difference of each Pokemon's stats against the average stats for its primary type.
  - [x] 5.2 Write the fact model `fct_competitive_moves` in `transform/models/marts/fct_competitive_moves.sql`. Join Pokemon with all their learnable moves, identify STAB (`is_stab`) by comparing move type with the Pokemon's primary or secondary type, and calculate `stab_adjusted_power` (multiplying power by 1.5 if STAB is true, normal power if false, and returning NULL if the move has no base power).
  - [x] 5.3 Configure dbt tests in `transform/models/marts/_marts.yml` to validate keys, check that BST is the sum of the individual stats, check that STAB-adjusted power is correctly calculated, and verify relationship integrations.
  - [x] 5.4 Run `dbt build` for the entire project to ensure all models compile, run, and pass their validation tests end-to-end.
  - [x] 5.5 Document all columns, calculations, and tables in the schema markdown file.

- [x] 6.0 Terraform Infrastructure Provisioning
  - [x] 6.1 Create `infra/main.tf`, `infra/variables.tf`, and `infra/outputs.tf` to provision three BigQuery datasets (`pokedex_raw`, `pokedex_staging`, `pokedex_marts`) and a GCS bucket for dlt staging files.
  - [x] 6.2 Test configuration using `terraform init`, `terraform validate`, and `terraform plan`.
  - [x] 6.3 Add cost tags and resource descriptions for resource observability.
  - [x] 6.4 Document variables and setup instructions in a README in `infra/`.

- [x] 7.0 Ingestion Pipeline Adaptation for BigQuery
  - [x] 7.1 Modify `ingestion/pokemon_pipeline.py` to check the `DESTINATION` environment variable (supporting `duckdb` and `bigquery`). Set up dynamic credentials loading for BigQuery, and configure GCS bucket staging for dlt loads to BigQuery.
  - [x] 7.2 Run local pytest suite `tests/test_pipeline.py` to verify that local ingestion to DuckDB remains unaffected and runs completely offline.
  - [x] 7.3 Add detailed logging inside the ingestion script to log the active destination and pipeline staging info.
  - [x] 7.4 Document GCP authentication configurations and environment variable instructions in code comments and the project README.

- [x] 8.0 Data Transformation Adaptation for BigQuery
  - [x] 8.1 Update `transform/profiles.yml` to add a `prod` target using the `dbt-bigquery` adapter configured to point to the datasets created by Terraform.
  - [x] 8.2 Verify model compilation with `dbt compile --target prod` and check for any BigQuery SQL syntax compatibility issues in model scripts.
  - [x] 8.3 Set up descriptive names and documentation mappings in the dbt configuration for the BigQuery production target.
  - [x] 8.4 Document the production profiles.yml schema in the dbt project README.

- [ ] 9.0 End-to-End Verification on GCP
  - [ ] 9.1 Run the ingestion pipeline targeting BigQuery (`DESTINATION=bigquery`) and execute `dbt build --target prod` to build and test the models in the cloud.
  - [ ] 9.2 Run database validation tests in BigQuery to verify row counts, column pivots, and that all standard dbt and custom data tests pass.
  - [ ] 9.3 Check ingestion logs and dlt loading packages to analyze GCS staging bucket cleanup and BigQuery performance metrics.
  - [ ] 9.4 Create a learning log `docs/learnings/` detailing GCP deployment experiences and any BigQuery schema/type differences.

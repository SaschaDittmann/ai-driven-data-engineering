# Prompt: Create the Project PRD

Copy the prompt below into your AI coding assistant.

~~~
Act as a Senior Data Architect. Create the Product Requirements Document (PRD) for a new data analytics project.

Use skill: create-prd

Important: The scope below is already well-defined. Only ask clarifying questions about areas that are genuinely ambiguous or missing. Do not re-ask about decisions that are already specified (like schema layout, testing strategy, or ingestion limits). If everything is clear, proceed directly to generating the PRD.

PROJECT OVERVIEW

Build a local-first data lakehouse for competitive Pokemon analytics using Python 3.11+, modern open-source frameworks, and a medallion architecture.

- Source: PokeAPI REST API (https://pokeapi.co/api/v2/)
- Target (Dev): Local DuckDB (data/pokedex.db)
- Target (Prod): Google BigQuery (to be set up in a later feature)
- Architecture: Raw (dlt) → Staging (dbt) → Marts (dbt)
- Target Audience: Competitive Pokemon players and data analysts building team strategies

FEATURE SCOPE

The PRD should cover two features that will be implemented together:

Feature 1 — Data Ingestion (dlt)
- Extract data from PokeAPI REST endpoints: pokemon, types, abilities, moves, stats
- Load into local DuckDB using dlt
- Use dlt's primary_key and write_disposition="merge" for idempotency
- Handle nested JSON (e.g., Pokemon stats, type arrays) through dlt's schema evolution
- Implement a generator-based resource approach
- Configurable Pokemon limit via environment variable POKEMON_LIMIT (default: 151 for dev/testing, set to 0 or unset for full fetch)
- Always fetch all types (there are only 18) and all stats (only 6) regardless of limit
- For moves and abilities: always fetch the full catalog from /move and /ability endpoints (they are small enough), regardless of POKEMON_LIMIT. The limit only controls how many Pokemon detail pages are fetched.
- Handle PokeAPI pagination (follow "next" URL in list responses)
- Retry on HTTP 429 with exponential backoff
- Use dlt's auto-schema evolution for nested JSON — do not manually flatten

Feature 2 — Data Transformation (dbt)
- Staging layer: Clean, typed, 1:1 mappings of raw dlt tables
- Marts layer with analytical models:
  - fct_pokemon_stats — Individual stats as columns (hp, attack, defense, sp_attack, sp_defense, speed), calculated BST (Base Stat Total), and each stat compared against the average of that stat for the Pokemon's primary type (e.g., "this Pikachu's speed vs. average speed of all Electric-types")
  - dim_type_effectiveness — Complete 18x18 matrix of the standard 18 Pokemon types (Normal, Fire, Water, etc.) with columns: attacking_type, defending_type, damage_multiplier (values: 2.0, 1.0, 0.5, 0.0). Source this from the PokeAPI /type endpoint's damage_relations.
  - fct_competitive_moves — Each Pokemon joined with ALL its learnable moves (no filtering — include every move from PokeAPI pokemon.moves), including move type/power/accuracy/damage_class, STAB flag (true when move type matches the Pokemon's primary OR secondary type), and STAB-adjusted power (power * 1.5 when STAB is true, NULL for status moves with no base power). The name "competitive" refers to the analytical purpose, not a filter on the data.
- dbt tests for uniqueness, not-null, accepted values, and relationship integrity

TECHNICAL REQUIREMENTS

1. Project Structure:
   - ingestion/ — dlt sources and pipeline scripts
   - transform/ — dbt project (models, tests, macros, schema.yml)
   - data/ — DuckDB database file (gitignored)
   - tests/ — End-to-end and integration tests (pytest)
   - docs/prds/ — PRD files
   - docs/tasks/ — Task breakdowns

2. Python: 3.11+, managed with uv
3. Dependencies: dlt[duckdb], dbt-core, dbt-duckdb, pytest, requests
4. Database Schemas:
   - dlt writes to a "raw" schema (e.g., raw.pokemon, raw.types)
   - dbt reads from "raw" and writes staging models to "staging" schema
   - dbt writes mart models to "marts" schema
   - All schemas live in the same DuckDB database (data/pokedex.db)
5. Testing:
   - Use a separate test DuckDB file (data/test_pokedex.db)
   - Mock/stub PokeAPI responses (using responses or pytest-httpserver) for fast, deterministic, offline-capable tests
   - Validate that tables are created, row counts > 0, and key columns exist
   - Use pytest with standard fixtures — no unittest.TestCase

NON-GOALS (for now)
- Cloud deployment (BigQuery, Terraform) — covered in a later feature
- Pipeline orchestration (Airflow) — covered in a later feature
- Visualization (Streamlit) — covered in a later feature
- Dual-type effectiveness combinations — single-type 18x18 matrix is sufficient
~~~

## Guidance for Answering

After the AI asks clarifying questions, answer them to shape the project scope.

- **When in doubt, pick the recommended option** — the defaults are designed to produce a well-scoped workshop project
- Most design decisions are already specified above — the AI should only ask about genuinely ambiguous areas
- **Don't overthink it** — the goal is to practice the *process* of creating a PRD with AI, not to design the perfect architecture

# Lab 2 — Transform It: Data Transformation with dbt

In this lab you'll switch from a CLI tool to an **IDE tool** and build dbt models on top of the raw data ingested in Lab 1. You'll create a staging layer (clean, typed) and a marts layer (analytical models with joins and business logic).

Same workflow, different tool — that's the point. The context engineering principles work everywhere.

## Learning Objectives

- Experience the same AI workflow in an IDE context (vs. CLI in Labs 0–1)
- Use `implement-tasks` to have AI build a complete dbt project
- Understand the medallion architecture (raw → staging → marts) through AI-generated code
- See how AI handles complex SQL logic (window functions, STAB calculations, type comparisons)

## Tools

| | |
|---|---|
| **Tool type** | IDE (Antigravity IDE (recommended) or Cursor) |
| **Environment** | Local (DuckDB) |
| **Duration** | 60–75 minutes |

## Prerequisites

- Lab 1 completed (data loaded in `data/pokedex.db`)
- Task file from Lab 0 exists in `docs/tasks/`
- Your IDE tool installed and configured for this project

## Steps

### Step 1 — Switch to Your IDE Tool (5 min)

1. Open **your project folder** (e.g., `~/my-pokedex-project`) in your IDE tool (Antigravity IDE (recommended) or Cursor). Do **not** open the workshop repo — open the project you created in Lab 0.
2. Verify the IDE detects the project rules (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, or `.cursorrules`) from your project root
3. **Verify the raw data exists** — Lab 2 depends on Lab 1's ingested data:
   ```bash
   # Check the database file exists
   ls -la data/pokedex.db

   # If missing, run the ingestion pipeline first
   uv run python ingestion/pipeline.py
   ```

### Step 2 — Create a Feature Branch (5 min)

Use the `git-worktree` skill to create an isolated branch for the transformation work.

1. Ask your AI assistant to create a worktree for the transformation feature
2. Verify you're on a new branch

### Step 3 — Implement the dbt Project (35–45 min)

Use the prompt from [`prompts/01_implement_transformation.md`](prompts/01_implement_transformation.md) to have your AI assistant build the dbt models.

1. Copy the prompt into your AI assistant
2. The AI will read the transformation tasks from `docs/tasks/` and start implementing
3. Watch it create the dbt project structure, staging models, and mart models

**What to observe:**
- Does the AI create a proper dbt project structure (`dbt_project.yml`, `profiles.yml`, models, etc.)?
- How does it handle the staging layer (1:1 mapping, renaming, type casting)?
- How does it implement the STAB calculation in the competitive moves model?
- Does it generate dbt tests in `schema.yml` files?

### Step 4 — Run dbt (10 min)

Build and test the dbt models.

1. Run dbt:
   ```bash
   cd transform
   dbt build
   ```
2. This runs both the models and the tests
3. Check the output — all models should materialize and all tests should pass
4. Query a mart model to verify the output makes sense:
   ```bash
   dbt show --select fct_pokemon_stats --limit 10
   ```

### Step 5 — Run End-to-End Tests (5 min)

1. Ask the AI to run the project tests:
   ```bash
   uv run pytest tests/ -v
   ```
2. The tests should validate data in both the raw tables and the dbt-created views/tables

### Step 6 — Finalize (5 min)

1. Ask your AI assistant to finalize the transformation tasks
2. Review the PR — does it include all dbt models, tests, and schema documentation?

## Checkpoints

- [ ] dbt project exists in `transform/` with `dbt_project.yml` and `profiles.yml`
- [ ] **Staging models:** Clean, typed, 1:1 mappings of raw tables (e.g., `stg_pokemon`, `stg_types`, `stg_moves`)
- [ ] **Mart model:** `fct_pokemon_stats` with BST calculation and per-type comparisons
- [ ] **Mart model:** `dim_type_effectiveness` with damage multiplier matrix
- [ ] **Mart model:** `fct_competitive_moves` with STAB (Same Type Attack Bonus) calculation
- [ ] `dbt build` passes (all models materialize, all tests pass)
- [ ] dbt tests defined in `schema.yml` (uniqueness, not-null, relationships)
- [ ] PR created via `finalize-tasks`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `dbt build` fails — can't find source tables | Run `ls data/pokedex.db` — if missing, run `uv run python ingestion/pipeline.py` first. Check that `profiles.yml` points to the correct DuckDB path |
| dbt can't find the profile | Create or check `profiles.yml` in the `transform/` directory — it should reference the DuckDB adapter |
| Staging models are too complex | Staging should be simple: `SELECT`, rename, cast. Push logic to the marts layer |
| STAB calculation is wrong | The rule: if `pokemon.type == move.type`, multiply damage by 1.5. Verify the join logic |
| AI creates too many models | Focus on the 3 core mart models listed in the checkpoints. Additional models are a nice-to-have |
| AI doesn't read the PRD or tasks | Make sure you opened your project folder (`~/my-pokedex-project`), not the workshop repo. The IDE agent reads rules from the workspace root |
| Context7 not providing dbt docs | Ask explicitly: "Use Context7 to look up dbt-duckdb adapter configuration" |

## Next

Continue to [Lab 3 — Ship It](../lab_3_cloud/README.md) where you'll adapt this pipeline for Google Cloud.

# Lab 1 — Ingest It: Data Ingestion with dlt

Time to build. In this lab you'll use the tasks created in Lab 0 to have your AI assistant implement a complete dlt ingestion pipeline — extracting data from the PokeAPI and loading it into a local DuckDB database.

This is the first time you'll run through the full implementation cycle: **branch → implement → test → learn → finalize**.

## Learning Objectives

- Use `git-worktree` to create an isolated feature branch
- Use `implement-tasks` to have AI build a dlt pipeline from your task list
- Experience how the PRD and task context from Lab 0 guides the AI's implementation
- Run and validate a data ingestion pipeline locally
- Use `finalize-tasks` to create a clean PR

## Tools

| | |
|---|---|
| **Tool type** | CLI (Claude Code or Antigravity CLI) |
| **Environment** | Local (DuckDB) |
| **Duration** | 60–75 minutes |

## Prerequisites

- Lab 0 completed (PRD and tasks exist in `docs/prds/` and `docs/tasks/`)
- Starter project set up with dependencies installed

## Steps

### Step 1 — Create a Feature Branch (5 min)

Use the `git-worktree` skill to create an isolated branch for the ingestion work.

1. Ask your AI assistant to create a worktree for the ingestion feature
2. Navigate into the new worktree
3. Verify you're on a new branch based off `development`

### Step 2 — Implement the Ingestion Pipeline (35–45 min)

This is the core of the lab. Use the prompt from [`prompts/01_implement_ingestion.md`](prompts/01_implement_ingestion.md) to have your AI assistant build the dlt pipeline.

1. Copy the prompt into your AI assistant
2. The AI will read the tasks from `docs/tasks/` and start implementing
3. Watch how it creates the dlt source, resources, and pipeline script
4. Let the AI work through the ingestion-related tasks from the task list

**What to observe:**
- How does the AI handle the PokeAPI's nested JSON structure?
- Does it use dlt's `primary_key` and `write_disposition` correctly?
- Does it create proper Python project structure?

### Step 3 — Run the Pipeline (10 min)

Execute the pipeline and verify the data landed correctly.

1. Run the dlt pipeline:
   ```bash
   uv run python ingestion/pipeline.py
   ```
2. Verify data in DuckDB — ask your AI assistant to help you query it:
   ```
   Show me the row counts for all tables in data/pokedex.db
   ```
3. Inspect a few tables to check schema correctness (nested data flattened properly, primary keys present)

### Step 4 — Run Tests (5 min)

1. Ask the AI to run the tests it created:
   ```bash
   uv run pytest tests/ -v
   ```
2. If tests fail, work with the AI to fix them

### Step 5 — Document Learnings (5 min)

Capture what you learned during this lab using the `document-learnings` skill.

1. Tell your AI assistant what you learned or what surprised you, for example:
   ```
   Use skill: document-learnings
   ```
2. The AI will create a file in `docs/learnings/` with the key takeaway
3. This builds a searchable knowledge base that the AI can reference in future labs

### Step 6 — Finalize (5 min)

Use the `finalize-tasks` skill to clean up and create a PR.

1. Ask your AI assistant to finalize the ingestion tasks
2. It will commit changes, check for conflicts, and create a PR targeting `development`
3. Review the PR description — does it accurately describe what was built?

## Checkpoints

- [ ] Feature branch created via `git-worktree`
- [ ] dlt pipeline script exists in `ingestion/`
- [ ] dlt source with resources for pokemon, types, abilities, moves, stats
- [ ] Pipeline runs successfully and loads data into `data/pokedex.db`
- [ ] DuckDB contains tables with data (check row counts)
- [ ] Nested JSON (stats, types) handled correctly (flattened or structured)
- [ ] Tests exist and pass
- [ ] PR created via `finalize-tasks`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| dlt pipeline fails with import errors | Check that `dlt[duckdb]` is installed: `uv pip install dlt[duckdb]` |
| PokeAPI rate limiting (429 errors) | Add a small delay between requests or reduce the number of endpoints initially |
| DuckDB file not created | Check the destination path — should be `data/pokedex.db` |
| AI doesn't follow the task list | Explicitly tell it to read `docs/tasks/` and work on the ingestion tasks |
| AI skips git-worktree | Some IDE tools restrict file access — the AI may fall back to `git checkout -b` instead. This is fine for the workshop |
| Nested data not handled well | Ask the AI to check dlt's documentation via Context7 for nested JSON handling |

## Next

Continue to [Lab 2 — Transform It](../lab_2_transformation/README.md) where you'll build dbt models on top of the data you just ingested.

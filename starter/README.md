# Pokedex Data Platform

A data lakehouse for competitive Pokemon analytics, built with modern open-source tools.

## Overview

This project ingests data from the [PokeAPI](https://pokeapi.co/api/v2/), transforms it through a medallion architecture (raw → staging → marts), and serves analytical models for competitive Pokemon analysis — stat comparisons, type effectiveness, and move pool optimization.

## Architecture

```
         PokeAPI (REST)
              |
         [ dlt Pipeline ]        Ingestion (Python)
              |
     +--------+--------+
     |                  |
  DuckDB            BigQuery     Storage
  (dev)              (prod)
     |                  |
     +--------+--------+
              |
        [ dbt Models ]           Transformation (SQL)
              |
     +--------+--------+--------+
     |        |        |        |
  staging   marts   Airflow  Streamlit
  models   models    DAGs    dashboard
```

### Data Layers

| Layer | Schema | Description |
|-------|--------|-------------|
| **Raw** | `raw` | Unmodified data as extracted from PokeAPI by dlt |
| **Staging** | `staging` | Cleaned, typed, 1:1 mappings of raw tables |
| **Marts** | `marts` | Analytical models with joins, aggregations, and business logic |

### Key Models

| Model | Description |
|-------|-------------|
| `fct_pokemon_stats` | Base stats with BST (Base Stat Total) and per-type comparisons |
| `dim_type_effectiveness` | Complete type matchup matrix (2x, 0.5x, 0x damage multipliers) |
| `fct_competitive_moves` | Move pool analysis with STAB (Same Type Attack Bonus) calculations |

## Tech Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Ingestion | [dlt](https://dlthub.com/) | Extract from PokeAPI, load into DuckDB/BigQuery |
| Transformation | [dbt](https://www.getdbt.com/) | SQL-based data modeling (staging + marts) |
| Dev Database | [DuckDB](https://duckdb.org/) | Local development and testing |
| Prod Database | [BigQuery](https://cloud.google.com/bigquery) | Production data warehouse |
| Infrastructure | [Terraform](https://www.terraform.io/) | GCP resource provisioning |
| Orchestration | [Apache Airflow](https://airflow.apache.org/) | Pipeline scheduling |
| Visualization | [Streamlit](https://streamlit.io/) | Interactive dashboard |

## Project Structure

```
.
├── ingestion/          # dlt sources and pipelines
├── transform/          # dbt project (models, tests, macros)
├── infra/              # Terraform configurations for GCP
├── app/                # Streamlit dashboard
├── tests/              # End-to-end and integration tests
├── data/               # Local DuckDB database (gitignored)
├── docs/
│   ├── prds/           # Product Requirements Documents
│   ├── tasks/          # Task breakdowns per feature
│   ├── learnings/      # Documented solutions and patterns
│   └── knowledge/      # Framework docs (e.g., llms-full.txt files for AI context)
├── AGENTS.md           # Shared agent instructions (all AI tools)
├── CLAUDE.md           # Project rules for Claude Code
├── GEMINI.md           # Project rules for Antigravity CLI
├── .cursorrules        # Project rules for Cursor IDE
├── .claude/            # Claude Code config (MCP servers)
├── .gemini/            # Antigravity CLI config (MCP servers)
├── .agents/skills/     # AI development workflow skills
└── requirements.txt    # Python dependencies
```

## Getting Started

### Prerequisites

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) (package manager)
- Git 2.20+

### Setup

```bash
# Create and activate virtual environment
uv venv
source .venv/bin/activate

# Install dependencies
uv pip install -r requirements.txt
```

### Run the Ingestion Pipeline

```bash
uv run python ingestion/pipeline.py
```

### Run dbt Models

```bash
cd transform
dbt build
```

### Run Tests

```bash
uv run pytest tests/
```

## Development Workflow

This project uses an AI-assisted development workflow defined in `.agents/skills/`:

1. **Plan** — `create-prd` to define requirements, `create-tasks` to break them down
2. **Branch** — `git-worktree` for isolated feature development
3. **Build** — `implement-tasks` for AI-assisted implementation with tests
4. **Learn** — `document-learnings` to capture solutions for future reference
5. **Ship** — `finalize-tasks` to clean up, resolve conflicts, and create PRs

See `AGENTS.md` for full details.

## License

[MIT](LICENSE)

# AI-Driven Data Engineering

**Stop prompting. Start engineering.**

A hands-on workshop that teaches experienced data engineers how to move beyond "Prompt-and-Pray" and turn AI into a reliable pair programmer for building production data platforms.

## The Problem

You already know how to build data pipelines, model data warehouses, and deploy to the cloud. But when you try to use AI to speed things up, you get stuck in a loop: paste a schema into a chat window, hope for usable SQL, manually fix the hallucinated joins, repeat. It works — sometimes. It scales — never.

The problem isn't the AI models. It's the absence of a reliable workflow around them.

## What This Workshop Teaches

This workshop gives you a **practical framework for AI-driven data engineering** — a structured methodology that transforms AI coding assistants from a nice gimmick into a dependable co-pilot for complex data ecosystems.

You'll learn how to:

- **Engineer context, not just prompts** — structure your projects with rules files (`CLAUDE.md`, `AGENTS.md`), PRDs, and task lists so AI produces consistent, production-quality output
- **Enforce standards through agent skills** — codify your coding guidelines, testing requirements, and workflow steps as reusable skills that AI follows automatically
- **Extend AI with live knowledge** — use MCP servers (like Context7) to give your AI assistant access to up-to-date framework documentation
- **Apply one workflow across tools** — the same methodology works in CLI tools (Claude Code, Antigravity CLI) and IDE tools (Antigravity IDE, Cursor)

## What You'll Build

By the end of the day, you'll have built a **complete data platform from scratch** — entirely through AI-assisted development:

```
                    PokeAPI (REST)
                         |
                    [ dlt Pipeline ]           <- Lab 1: Ingestion
                         |
                 +-------+-------+
                 |               |
              DuckDB         BigQuery          <- Lab 3: Go to Cloud
              (local)         (GCP)
                 |               |
            [ dbt Models ]                     <- Lab 2: Transformation
            staging + marts
                 |
       +---------+---------+
       |         |         |
   Airflow   Streamlit   BQML/Gemini          <- Optional Labs
```

The data source is **PokeAPI** — a free, public REST API with a rich, nested data model (Pokemon, types, stats, moves, evolution chains). It's fun, it requires zero setup, and its complexity mirrors real-world data engineering challenges: nested JSON, one-to-many relationships, and multi-entity joins.

## The Journey

The workshop follows a progressive build. Each lab adds one layer to the solution, and each lab reinforces the same AI development workflow: **plan → implement → test → learn → finalize**.

### Intro — Foundations of AI-Driven Development (60 min)

Before touching code, you'll learn the framework that makes everything else work: context engineering, agent skills, MCP servers, and how to structure a data engineering project so AI can reliably act on it. You'll set up your tools and clone the pre-configured starter project.

### Lab 0 — Plan It (60–75 min)

> **Tool type:** CLI | **Environment:** Local

Your first interaction with AI as a pair programmer. Using the `create-prd` skill, you'll guide the AI through a structured requirements conversation to produce a Product Requirements Document for the data platform. Then use `create-tasks` to break it into actionable implementation tasks.

This is where most people's "vibe coding" goes wrong — they skip planning and jump straight to code. You'll see why starting with a PRD changes everything.

### Lab 1 — Ingest It (60–75 min)

> **Tool type:** CLI | **Environment:** Local (DuckDB)

Time to build. Using the tasks from Lab 0, you'll have AI create a dlt pipeline that extracts data from the PokeAPI and loads it into a local DuckDB database. You'll experience the full implementation cycle: create a feature branch with `git-worktree`, implement with `implement-tasks`, run and test the pipeline, then finalize with a clean PR.

### Lab 2 — Transform It (60–75 min)

> **Tool type:** IDE | **Environment:** Local (DuckDB)

Switch from CLI to IDE — same workflow, different tool. You'll have AI build a dbt project with staging models (clean, typed, 1:1 mappings of raw data) and analytical marts (stat comparisons, type effectiveness matrices, competitive move analysis with STAB calculations).

### Lab 3 — Ship It (60–75 min)

> **Tool type:** IDE | **Environment:** Local + GCP

Requirements change — just like in the real world. You'll update the PRD with cloud requirements, generate new tasks, then have AI produce Terraform files for GCP infrastructure (BigQuery datasets, GCS buckets, IAM). Apply the infrastructure, adapt the pipeline for BigQuery, and run everything end-to-end on GCP.

### Optional Labs — Go Further

For faster groups or extended workshop formats:

| Lab | What You Build |
|-----|---------------|
| **4a — Orchestrate It** | An Airflow DAG that schedules the full pipeline |
| **4b — Visualize It** | A Streamlit dashboard with power rankings, type heatmaps, and move analytics |
| **4c — AI/ML on It** | A BQML model to predict Pokemon types from stats + Gemini-powered scouting reports |

## Tech Stack

All core tools are **open source** — the skills you learn transfer to any cloud or on-prem environment.

| Layer | Tool |
|-------|------|
| Ingestion | [dlt](https://dlthub.com/) (data load tool) |
| Transformation | [dbt](https://www.getdbt.com/) |
| Local Database | [DuckDB](https://duckdb.org/) |
| Cloud Database | [BigQuery](https://cloud.google.com/bigquery) (GCP) |
| Infrastructure | [Terraform](https://www.terraform.io/) |
| Orchestration | [Apache Airflow](https://airflow.apache.org/) (optional) |
| Visualization | [Streamlit](https://streamlit.io/) (optional) |
| AI/ML | [BQML](https://cloud.google.com/bigquery/docs/bqml-introduction) + [Gemini](https://cloud.google.com/bigquery/docs/generate-text) (optional) |

## AI Tools

Each lab focuses on a tool *category* — you choose which specific tool to use:

| Category | Recommended | Alternative |
|----------|-------------|-------------|
| **CLI** (Labs 0–1) | Claude Code, Antigravity CLI | — |
| **IDE** (Lab 2) | Antigravity IDE | Cursor |
| **Labs 3+** | Your choice — you've tried both, pick what works for you | |

The workshop methodology is tool-agnostic. The same context engineering principles apply everywhere.

## Prerequisites

**See the [Setup Guide](SETUP.md) for detailed installation instructions.**

Quick summary — install before the workshop:

- **Python 3.11+** and [uv](https://docs.astral.sh/uv/) (package manager)
- **Git** (2.20+)
- **Node.js** (18+) — required for MCP servers
- **One CLI tool:** [Claude Code](https://docs.anthropic.com/en/docs/claude-code) or Antigravity CLI
- **One IDE tool:** Antigravity IDE (recommended) or [Cursor](https://cursor.sh/) (alternative)
- **Terraform** (1.0+) — for Lab 3

**Provided at the workshop:**
- GCP project access (pre-provisioned playground)
- AI model API keys

## Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/<org>/ai-driven-data-engineering.git
cd ai-driven-data-engineering/starter

# 2. Set up Python environment
uv venv
uv pip install -r requirements.txt

# 3. Verify your AI tool
claude --version    # or your chosen tool

# 4. Start Lab 0
# Follow the instructions in labs/lab_0_context_engineering/README.md
```

## Repo Structure

```
ai-driven-data-engineering/
├── starter/              # Your starting point — pre-configured project scaffold
├── labs/
│   ├── lab_0_context_engineering/    # Plan it
│   ├── lab_1_ingestion/             # Ingest it
│   ├── lab_2_transformation/        # Transform it
│   ├── lab_3_cloud/                 # Ship it
│   ├── lab_4a_orchestration/        # Orchestrate it (optional)
│   ├── lab_4b_visualization/        # Visualize it (optional)
│   └── lab_4c_ai_ml/               # AI/ML on it (optional)
└── docs/                 # Workshop outline and planning
```

Each lab contains:
- `README.md` — Learning objectives, instructions, and checkpoints
- `prompts/` — The prompts you'll use with your AI tool
- `solutions/` — Reference implementations for validation and catch-up

## License

[MIT](LICENSE)

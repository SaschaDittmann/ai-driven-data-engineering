# Prompt: Create PRD for the Dashboard

Copy the prompt below into your AI coding assistant.

~~~
Act as a Senior Full-Stack Data Engineer. Create a Product Requirements Document (PRD) for a data visualization dashboard.

Use skill: create-prd

FEATURE SCOPE

Build a multi-tab Streamlit web application to visualize the mart-layer insights for competitive Pokemon analytics.

- Backend: Connection to the local DuckDB data/pokedex.db (or BigQuery if Lab 3 is completed)
- Location: All application code in the app/ directory

DASHBOARD TABS

1. Power Rankings — Searchable table of Pokemon with Base Stat Total (BST). Radar chart to compare stats of two selected Pokemon side by side.

2. Type Synergy & Counters — Heatmap visualization of the type effectiveness matrix from dim_type_effectiveness. Interactive tool: select an opponent's Pokemon and see top 5 counters based on type advantages.

3. Move Pool Analytics — Distribution plot of move accuracy vs. power. List of highest damage dealers per type, factoring in STAB bonus from fct_competitive_moves.

TECHNICAL REQUIREMENTS

- Use duckdb Python library (or google-cloud-bigquery) to query the mart models directly
- Use plotly or altair for interactive charts
- Sidebar with global filters (e.g., generation, primary type) that persist across tabs
- Project structure:
  - app/main.py — Entry point
  - app/utils.py — Database connection and SQL queries
  - app/visuals.py — Chart generation functions
~~~

# Prompt: Implement the Streamlit Dashboard

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the visualization tasks in docs/tasks/ and implement the Streamlit dashboard.

KEY REQUIREMENTS

- Location: All code in app/ directory
- Data source: DuckDB (data/pokedex.db) or BigQuery (if Lab 3 completed)
- Charts: Use plotly for interactive visualizations

APP STRUCTURE

app/
├── main.py          # Streamlit entry point, tab navigation, sidebar filters
├── utils.py         # Database connection, SQL query functions
└── visuals.py       # Chart generation functions (radar, heatmap, scatter)

TAB IMPLEMENTATIONS

Tab 1: Power Rankings
- Query fct_pokemon_stats for the searchable table
- Radar chart comparing two selected Pokemon across 6 stat dimensions
- Sort by BST (Base Stat Total) by default

Tab 2: Type Synergy
- Query dim_type_effectiveness for the heatmap data
- Use a Plotly heatmap with attacking types on X, defending types on Y
- Color scale: red (2x), white (1x), blue (0.5x), black (0x)

Tab 3: Move Pool
- Query fct_competitive_moves
- Scatter plot: move power (X) vs accuracy (Y), colored by damage class
- Table of top damage dealers per type, using STAB-adjusted power

GLOBAL FILTERS (Sidebar)

- Primary type dropdown (filters all tabs)
- Generation filter (if data supports it)
- Filters should persist across tab switches using st.session_state

TESTING

- Verify the app starts without errors
- Check that each tab renders with data
~~~

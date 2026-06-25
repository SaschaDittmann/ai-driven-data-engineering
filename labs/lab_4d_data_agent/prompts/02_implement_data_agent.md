# Prompt: Implement the Data Agent

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the data agent tasks in docs/tasks/ and implement the ADK-based data agent.

Important: Before implementing, read the Google ADK documentation in docs/knowledge/google-adk.txt for API patterns, agent configuration, and tool setup. This file contains the latest ADK documentation.

KEY REQUIREMENTS

- Framework: Google Agent Development Kit (google-adk)
- Model: gemini-2.5-flash (or latest available)
- Location: All code in agent/ directory
- Data source: BigQuery marts layer (fct_pokemon_stats, dim_type_effectiveness, fct_competitive_moves)

AGENT STRUCTURE

agent/
├── __init__.py
├── main.py              # CLI runner with interactive conversation loop
├── agent.py             # Agent definition with BigQuery toolset
└── prompts.py           # System prompt with data model context

IMPLEMENTATION

1. Agent Definition (agent.py):
   - Create an ADK Agent with Gemini model
   - Use the ADK BigQuery Toolset for SQL execution
   - Configure with GCP project ID and dataset from environment variables

2. System Prompt (prompts.py):
   - Describe the available tables and their columns:
     * fct_pokemon_stats: pokemon_id, pokemon_name, primary_type, secondary_type, hp, attack, defense, sp_attack, sp_defense, speed, base_stat_total, *_vs_type_avg columns
     * dim_type_effectiveness: attacking_type, defending_type, damage_multiplier
     * fct_competitive_moves: pokemon_name, move_name, move_type, power, accuracy, damage_class, is_stab, stab_adjusted_power
   - Include the BigQuery dataset prefix (e.g., pokedex_marts)
   - Add example questions the agent can answer

3. Runner (main.py):
   - Interactive CLI loop that accepts user questions
   - Async conversation with the agent
   - Print agent responses and any SQL queries executed
   - Exit on "quit" or "exit"

4. Optional — Analytics Plugin:
   - Add BigQuery Agent Analytics plugin to log agent events
   - Configure logging to a separate BigQuery dataset (e.g., pokedex_agent_logs)

TESTING

- Verify the agent starts without errors
- Test with sample questions:
  * "Which Pokemon has the highest BST?"
  * "What types are super effective against Steel?"
  * "Show me the top 5 STAB moves for Gengar"
~~~

## While the AI Works

Observe how it:
- Configures the BigQuery toolset with ADK
- Writes the system prompt (does it include enough schema context?)
- Handles the async conversation loop
- Uses Context7 to look up the latest ADK API

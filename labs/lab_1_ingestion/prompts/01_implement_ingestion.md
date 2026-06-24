# Prompt: Implement the Ingestion Pipeline

Copy the prompt below into your AI coding assistant.

~~~
Use skill: implement-tasks

Read the tasks in docs/tasks/ and implement all ingestion-related tasks (everything related to dlt and data extraction/loading). Focus on building the dlt pipeline that extracts data from the PokeAPI and loads it into a local DuckDB database. Do not work on the transformation/dbt tasks — those are for Lab 2.

KEY REQUIREMENTS

- Source: PokeAPI REST API (https://pokeapi.co/api/v2/)
- Endpoints: pokemon, types, abilities, moves, stats
- Destination: Local DuckDB at data/pokedex.db
- Location: All ingestion code in ingestion/ directory
- Framework: Use dlt with the following patterns:
  - Generator-based resources for each endpoint
  - primary_key on each resource for idempotency
  - write_disposition="merge" for safe re-runs
  - Let dlt handle nested JSON via auto-schema evolution

IMPLEMENTATION NOTES

- Start with a pokemon resource to verify the pipeline works, then add remaining endpoints
- Use requests to call the PokeAPI — handle pagination (the API returns paginated lists)
- Add basic error handling for HTTP errors and rate limiting (429)
- Create a main pipeline script at ingestion/pipeline.py that can be run directly

TESTING

- Create end-to-end tests in tests/ using pytest
- Use a separate test database (data/test_pokedex.db)
- Mock/stub PokeAPI responses (using responses or pytest-httpserver) for fast, offline-capable tests
- Tests should verify:
  - Tables are created in the test DuckDB
  - Row counts are greater than zero
  - Key columns exist (e.g., id, name)
  - POKEMON_LIMIT is respected
~~~

## While the AI Works

Observe how it:
- Structures the dlt source and resources
- Handles the PokeAPI's paginated responses
- Deals with nested JSON data (Pokemon stats, type arrays)

If the AI asks questions, answer based on the PRD in `docs/prds/`.

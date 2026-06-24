# Prompt: Create the Task Breakdown

Copy the prompt below into your AI coding assistant.

~~~
Use skill: create-tasks

Break down the PRD in docs/prds/ into implementation tasks.

Focus on creating vertical slices — each parent task should include implementation, tests, and documentation as a shippable unit.

Split the work into two major areas:
1. Ingestion tasks (dlt pipeline) — these will be implemented in Lab 1
2. Transformation tasks (dbt models) — these will be implemented in Lab 2
~~~

## After the AI Responds

**When the AI presents the high-level parent tasks**, review them:
- Do they cover both ingestion and transformation?
- Is each parent task a complete vertical slice?
- Are the tasks in a logical implementation order (ingestion before transformation)?

If the tasks look good, type **"Go"** to generate the detailed sub-tasks.

**After the detailed breakdown is generated**, check:
- Are specific file paths listed? (e.g., `ingestion/pipeline.py`, `transform/models/staging/stg_pokemon.sql`)
- Does each parent task include testing sub-tasks?
- Is the "Relevant Files" section complete?

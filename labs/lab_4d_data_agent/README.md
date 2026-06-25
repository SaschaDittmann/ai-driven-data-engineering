# Lab 4d — Talk to It: Build a Data Agent with Google ADK

*Optional lab — for faster groups, extended workshops, or take-home exercise.*

In this lab you'll build a conversational data agent using the **Google Agent Development Kit (ADK)** that lets users ask natural-language questions about the Pokemon data in BigQuery. Instead of writing SQL, users simply ask "Which Fire-type Pokemon has the highest speed?" and the agent generates and executes the query.

This is the capstone of the workshop: you built the data platform, now you make it accessible to anyone through conversation.

## Learning Objectives

- Use the full AI workflow cycle (PRD → tasks → implement → finalize) for an agent feature
- Build a conversational data agent using Google ADK with Gemini
- Connect the agent to BigQuery using the ADK BigQuery Toolset
- Optionally add agent analytics logging back to BigQuery

## Tools

| | |
|---|---|
| **Tool type** | CLI or IDE (your choice) |
| **Environment** | GCP (BigQuery) |
| **Duration** | 60–75 minutes |

## Prerequisites

- Lab 3 completed (data available in BigQuery)
- GCP Playground with Vertex AI API enabled
- `gcloud` CLI authenticated

## Steps

### Step 1 — Download ADK Documentation (2 min)

Download the Google ADK documentation so your AI tool can reference it during implementation:

```bash
mkdir -p docs/knowledge
curl -o docs/knowledge/google-adk.txt https://adk.dev/llms-full.txt
```

This file is used by the `implement-tasks` skill to look up ADK APIs and patterns.

### Step 2 — Create a PRD for the Data Agent (10 min)

1. Copy the prompt from [`prompts/01_create_prd.md`](prompts/01_create_prd.md) into your AI assistant
2. Answer clarifying questions based on the prompt guidance
3. Review the generated PRD

### Step 3 — Create Tasks and Implement (40–50 min)

1. Use `create-tasks` to generate task breakdowns
2. Create a feature branch with `git-worktree`
3. Use `implement-tasks` with the prompt from [`prompts/02_implement_data_agent.md`](prompts/02_implement_data_agent.md)
4. The AI should create:
   - An ADK agent that connects to BigQuery and answers data questions
   - System prompt with context about the Pokemon data model (marts layer)
   - A runner script to interact with the agent locally
   - Optionally: BigQuery Agent Analytics plugin for logging agent events

### Step 4 — Run and Test (10–15 min)

1. Start the agent:
   ```bash
   uv run python agent/main.py
   ```
2. Try asking questions like:
   - "Which Pokemon has the highest Base Stat Total?"
   - "Show me all Fire-type Pokemon with speed above 100"
   - "What are the top 5 STAB moves for Charizard?"
   - "Which types are super effective against Dragon?"
3. Observe how the agent generates SQL and queries the mart models
4. Document what you learned:
   ```
   Use skill: document-learnings
   ```
5. Use `finalize-tasks` to create a PR

## Checkpoints

- [ ] PRD for data agent feature exists
- [ ] ADK agent created in `agent/` directory
- [ ] Agent connects to BigQuery and queries mart models
- [ ] Agent answers natural-language questions about Pokemon data
- [ ] System prompt includes context about the data model (tables, columns, relationships)
- [ ] Agent runs locally via CLI
- [ ] PR created

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `google-adk` not installed | Run `uv pip install google-adk` |
| Agent can't connect to BigQuery | Check `gcloud auth application-default login` and verify the GCP project is set |
| Agent generates wrong SQL | Improve the system prompt with more detail about table schemas and column descriptions |
| Agent hallucinates table names | Add the exact table names from your marts layer to the system prompt |

## Falling Behind?

If you didn't complete previous labs or want to start fresh with the reference solutions:

```bash
# macOS/Linux
bash labs/lab_4d_data_agent/prepare.sh ~/my-pokedex-project

# Windows (PowerShell)
.\labs\lab_4d_data_agent\prepare.ps1 -ProjectDir ~\my-pokedex-project
```

This copies Lab 0-3 reference solutions into your project and runs the ingestion pipeline if needed.

## Next

Try another optional lab:
- [Lab 4a — Orchestrate It](../lab_4a_orchestration/README.md)
- [Lab 4b — Visualize It](../lab_4b_visualization/README.md)
- [Lab 4c — AI/ML on It](../lab_4c_ai_ml/README.md)

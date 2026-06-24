# Lab 0 — Plan It: Context Engineering & Project Planning

In this lab, you'll use your AI coding assistant for the first time — not to write code, but to **plan the project**. You'll create a Product Requirements Document (PRD) and break it into actionable tasks using the pre-configured skills in your starter project.

This is where most "vibe coding" goes wrong: people jump straight to implementation. By starting with structured planning, you give the AI the context it needs to produce consistent, high-quality output in Labs 1 and 2.

## Learning Objectives

- Experience the `create-prd` skill: guided requirements gathering through AI conversation
- Experience the `create-tasks` skill: AI-driven task decomposition into vertical slices
- Understand how PRDs and task files serve as persistent context for future AI interactions
- See the difference between a vague prompt and a well-structured planning session

## Tools

| | |
|---|---|
| **Tool type** | CLI (Claude Code or Antigravity CLI) |
| **Environment** | Local |
| **Duration** | 60–75 minutes |

## Prerequisites

- Starter project cloned and set up (see `starter/README.md`)
- Python environment active with dependencies installed
- Your CLI tool configured and working

## Steps

### Step 1 — Explore the Starter Project (10 min)

Before you start prompting, take a few minutes to understand the project scaffold that's already in place.

1. Open your terminal and navigate to your project directory
2. Explore the key files:
   - `CLAUDE.md` — Project-level instructions for your AI assistant
   - `AGENTS.md` — Agent workflow rules, coding standards, and testing guidelines
   - `.agents/skills/` — The 6 skills that define your development workflow
3. Start your AI coding assistant in the project directory

### Step 2 — Create the PRD (30 min)

Now use the `create-prd` skill to generate a Product Requirements Document. The AI will ask you clarifying questions — your answers shape the scope of the entire project.

1. Copy the prompt from [`prompts/01_create_prd.md`](prompts/01_create_prd.md) into your AI assistant
2. The AI will ask clarifying questions about the project scope — answer them based on the guidance in the prompt
3. Review the generated PRD in `docs/prds/`
4. Refine if needed: ask the AI to adjust scope, add details, or restructure sections

**Tips:**
- The AI will ask clarifying questions with recommended defaults — **when in doubt, pick the recommended option**. The prompt file has guidance on sensible answers.
- Don't overthink the answers — the goal is to practice the *process*, not design the perfect architecture
- Once the PRD is generated, don't just accept it — iterate on it like you would with a colleague
- Pay attention to the functional requirements section — this drives the tasks in the next step
- Make sure the PRD covers both ingestion (dlt) and transformation (dbt) scope

### Step 3 — Create the Task Breakdown (20 min)

With the PRD in place, use the `create-tasks` skill to break it into implementation tasks.

1. Copy the prompt from [`prompts/02_create_tasks.md`](prompts/02_create_tasks.md) into your AI assistant
2. The AI will generate high-level parent tasks first — review them before proceeding
3. When prompted, type **"Go"** to generate the detailed sub-tasks
4. Review the task file in `docs/tasks/`

**Tips:**
- Each parent task should be a complete vertical slice (code + tests + docs)
- Check that the tasks align with what the PRD describes
- The task list is what you'll work through in Labs 1 and 2

### Step 4 — Review and Validate (10 min)

Take a step back and review what your AI assistant produced.

1. Read through the PRD — does it accurately describe the project?
2. Read through the tasks — are they actionable? Do they cover the full scope?
3. Make any final adjustments

Ask yourself: *"If I handed these documents to a colleague (or an AI), could they build the project without additional context?"* If yes, you're ready for Lab 1.

## Checkpoints

- [ ] PRD file exists in `docs/prds/` (e.g., `prd-pokedex-data-platform.md`)
- [ ] PRD covers ingestion scope (PokeAPI endpoints, dlt, DuckDB destination)
- [ ] PRD covers transformation scope (dbt staging + marts models)
- [ ] Task file exists in `docs/tasks/` (e.g., `tasks-prd-pokedex-data-platform.md`)
- [ ] Tasks are broken into vertical slices with implementation + testing sub-tasks
- [ ] Tasks cover both ingestion and transformation features

## Troubleshooting

| Issue | Solution |
|-------|----------|
| AI doesn't use the `create-prd` skill | Make sure you're in the project directory with `CLAUDE.md` and `.agents/skills/` present |
| PRD is too vague | Provide more specific answers during the clarification phase — mention specific endpoints, schemas, and tools |
| PRD scope is too large | Focus on core endpoints (pokemon, types, abilities, moves) and basic staging + marts models |
| Tasks are too high-level | Ask the AI to add more granular sub-tasks with specific file paths and test requirements |

## Next

Continue to [Lab 1 — Ingest It](../lab_1_ingestion/README.md) where you'll implement the ingestion pipeline using the tasks you just created.

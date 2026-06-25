---
date: 2026-06-25
topic: ADK Web Root Agent Discovery Fix
---

# ValueError: No root_agent found for 'agent'

## The Problem / Context
When attempting to run the ADK Web Dev Server via `adk web agent`, the agent loader crashed with the following error:
`ValueError: No root_agent found for 'agent'. Searched in 'agent.agent.root_agent', 'agent.root_agent' and 'agent/root_agent.yaml'.`

This occurred because the `Agent` and `App` instances were created locally inside the function `initialize_agent_and_runner(session_service)` in `agent/agent.py`. The ADK `AgentLoader` expects a module-level variable named `root_agent` or `app` to successfully discover and load the agent configuration.

## The Solution / Learning
The solution was to:
1. Instantiated and exposed `root_agent` and `app` as module-level global variables in `agent/agent.py`.
2. Wrapped the module-level instantiation inside a check for `GCP_PROJECT_ID` and a generic try-except block. This ensures that the module can still be imported cleanly during unit tests (where environment variables are set dynamically or mocked inside the test logic) or in clean environments without credentials.
3. Left the dynamic instantiation in `initialize_agent_and_runner(session_service)` unchanged to ensure compatibility with unit tests and other runners that modify environment settings at runtime.

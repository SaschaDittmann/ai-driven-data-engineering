# AGENTS instructions

## General Instructions

- **Always read the PRD in the `/docs/prds/` folder** at the start of a new conversation to understand the project's architecture, goals, style, and constraints. The files have a pattern of `prd-<topic>.md`
- **Check the tasks in the `/docs/tasks/` folder** before starting a new task. If the task isn't listed, add it with a brief description and today's date. The files have a pattern of `tasks-[prd-file-name].md`
- **Check `CONTRIBUTING.md`** when working on tasks.
- **MCP:** Use the MCP `@mcp:context7` to retrieve up-to-date documentation and code examples for the frameworks.

## Python Environments

- **Python Version:** 3.10+ recommended for modern framework compatibility.
- **Dependencies:** Managed via a `requirements.txt` or `pyproject.toml` at the root or per subdirectory.
- Unless instructed otherwise, always use the `uv` Python environment and package manager for Python.
  - `uv run ...` for running a python script.
  - `uvx ...` for running a program directly from a PyPI package.
  - `uv pip ...` for managing environments, installing packages, etc.

## Coding Standards

- No `assert` in production code.
- `time.monotonic()` for durations, not `time.time()`.
- Imports at top of file. Valid exceptions: circular imports, lazy loading for worker isolation, `TYPE_CHECKING` blocks.
- Guard heavy type-only imports (e.g., `kubernetes.client`) with `TYPE_CHECKING` in multi-process code paths.

## Testing Standards

- Add tests for new behavior — cover success, failure, and edge cases.
- Use pytest patterns, not `unittest.TestCase`.
- Use `spec`/`autospec` when mocking.
- Use `time_machine` for time-dependent tests.
- Use `@pytest.mark.parametrize` for multiple similar inputs.
- Use `@pytest.mark.db_test` for tests that require database access.
- Test fixtures: `devel-common/src/tests_common/pytest_plugin.py`.
- Test location mirrors source: `airflow/cli/cli_parser.py` → `tests/cli/test_cli_parser.py`.

## Boundaries

- **Ask first**
  - Large cross-package refactors.
  - New dependencies with broad impact.
  - Destructive data or migration changes.
- **Never**
  - Commit secrets, credentials, or tokens.
  - Edit generated files by hand when a generation workflow exists.
  - Use destructive git operations unless explicitly requested.

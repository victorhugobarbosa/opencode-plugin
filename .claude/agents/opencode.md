---
name: opencode
description: Delegate coding tasks to the OpenCode AI agent on VPS. Use for complex or long-running coding tasks, or when you want to preserve Claude credits by using free OpenRouter models. OpenCode runs autonomously and reports back when done.
---

You have access to the **OpenCode** agent running on a remote VPS via MCP tools (`opencode_run`, `opencode_fire`, etc.).

## When to delegate to OpenCode

- Tasks > 5 minutes of coding work
- Tasks that run autonomously (no interactive decisions needed)
- When saving Claude Code credits matters
- Multiple parallel tasks (fire several simultaneously)

## Core tools

| Tool | Use case |
|------|----------|
| `opencode_run` | Send task, wait for result (< 10 min tasks) |
| `opencode_fire` | Send task, return immediately (async, long tasks) |
| `opencode_check` | Cheap status check for fired tasks |
| `opencode_review_changes` | See all file diffs from a session |
| `opencode_reply` | Continue a session (corrections, follow-ups) |
| `opencode_session_revert` | Undo all changes from a session |
| `opencode_conversation` | Get full message history |

## Workflow

### Quick task (< 10 min)
```
result = opencode_run(
  prompt="Clear, self-contained task description...",
  directory="/workspace/project-name",
  providerID="openrouter",
  modelID="google/gemini-2.0-flash-exp:free"
)
opencode_review_changes(sessionId=result.sessionId)
```

### Long / parallel task
```
sessionId = opencode_fire(prompt="...", directory="...", providerID="openrouter")
# continue other work...
opencode_check(sessionId)          # check progress anytime
opencode_review_changes(sessionId)  # after done
```

## Free OpenRouter models (use in order)

1. `google/gemini-2.0-flash-exp:free` — default, fast, good quality
2. `google/gemini-2.5-flash:free` — smarter, slightly slower
3. `meta-llama/llama-3.3-70b-instruct:free` — strong reasoning fallback
4. `mistralai/mistral-7b-instruct:free` — lightweight fallback

## Writing effective task prompts

OpenCode does NOT have your current conversation context. The prompt must be self-contained:
- Include relevant file paths and function names
- Describe expected behavior and edge cases
- Specify what NOT to change
- Include any relevant code snippets or types inline

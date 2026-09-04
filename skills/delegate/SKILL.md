---
name: delegate
description: How to delegate a coding task to OpenCode on VPS using free OpenRouter models. Provides templates and model selection guidance.
---

## Delegating to OpenCode

Use `opencode_run` (sync) or `opencode_fire` (async) with these parameters:

| Parameter | Value |
|-----------|-------|
| `prompt` | Self-contained task description (no assumed context) |
| `directory` | Absolute path to project on VPS |
| `providerID` | `"openrouter"` |
| `modelID` | Free model ID (see below) |

## Free models (openrouter provider)

| modelID | Speed | Best for |
|---------|-------|----------|
| `google/gemini-2.0-flash-exp:free` | Fast | Most tasks (default) |
| `google/gemini-2.5-flash:free` | Fast | Complex reasoning |
| `meta-llama/llama-3.3-70b-instruct:free` | Medium | Code generation |
| `mistralai/mistral-7b-instruct:free` | Fast | Simple tasks |

If a model returns quota error, try the next one in the list.

## Prompt template

```
Task: [one-line summary]

Context:
- File: [path/to/file.ext]
- Function/component: [name]
- Current behavior: [what it does now]
- Expected behavior: [what it should do]

Requirements:
1. [specific requirement]
2. [specific requirement]

Do NOT modify: [list files/functions to leave untouched]

[Include any relevant code snippets, types, or error messages]
```

## After completion

```
# Review changes
opencode_review_changes(sessionId)

# Request corrections
opencode_reply(sessionId, "Fix X: the Y should be Z")

# Undo everything
opencode_session_revert(sessionId)

# Check async task
opencode_check(sessionId)
```

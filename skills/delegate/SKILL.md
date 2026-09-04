---
name: delegate
description: Delegate a coding task to OpenCode on VPS using free models, with automatic provider/model fallback on quota and server errors. Use when sending work to OpenCode or when an OpenCode call fails.
---

## Sending a task

`opencode_run` (sync, <10min) or `opencode_fire` (async, long tasks):

| Parameter | Value |
|-----------|-------|
| `prompt` | Self-contained task description (no assumed context) |
| `directory` | Absolute path to project on VPS |
| `providerID` | From fallback chain below |
| `modelID` | From fallback chain below |

Always start at step 1 of the chain. Never skip ahead — Zen models are
exhausted first so the OpenRouter key stays unspent as long as possible.

## Fallback chain

| # | providerID | modelID |
|---|------------|---------|
| 1 | `opencode` | `mimo-v2.5-free` |
| 2 | `opencode` | `muse-spark-1.2-contributor-free` |
| 3 | `opencode` | `x-preview-f-free` |
| 4 | `openrouter` | `minimax/minimax-m2.7:free` |
| 5 | `openrouter` | `z-ai/glm-5.2:free` |
| 6 | `openrouter` | `minimax/minimax-m3:free` |
| 7 | `openrouter` | `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free` |
| 8 | `openrouter` | `google/gemma-4-26b-a4b-it:free` |

Steps 1-3 use Zen credits. Steps 4-8 spend the OpenRouter key.

If the chain is exhausted, stop and report which step failed and why.
Do not fall back to a paid model without asking.

## Error triage

Read the error before reacting — the response differs by cause.

| Error signal | Action |
|---|---|
| `429`, quota, rate limit, credits exhausted, `insufficient_quota` | Advance one step. No retry — the model is out, retrying wastes a call. |
| `5xx`, timeout, connection reset, empty response | Retry the **same** model **once**. Still failing → advance one step. |
| `401`, `403`, invalid API key | **Stop.** Report it. Advancing the chain will not fix a bad key, and every later step on the same provider fails identically. |
| Model returned bad or incomplete code | **Do not change model.** Correct with `opencode_reply` in the same session. |

One retry per step, maximum. Never loop a step.

When you advance, say which model you moved to and why in one line, so
the quota state stays visible.

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

OpenCode has none of your conversation context. Anything the task depends
on goes in the prompt.

## After completion

```
opencode_review_changes(sessionId)              # see the diffs
opencode_reply(sessionId, "Fix X: Y should be Z")  # request corrections
opencode_session_revert(sessionId)              # undo everything
opencode_check(sessionId)                       # progress of a fired task
```

## Checking what is actually available

The chain above is a snapshot. Free model IDs change and get retired.
If a step fails with "model not found" rather than a quota error, the ID
is stale — call `opencode_provider_models` to list what the provider
currently offers, use that, and report the drift.

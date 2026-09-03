#!/bin/sh
set -e

# Create opencode config dir
mkdir -p "$HOME/.config/opencode"

# Write opencode.jsonc with provider config from env vars
printf '{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "openrouter": {
      "apiKey": "%s"
    }
  },
  "model": "openrouter/%s"
}\n' \
  "${OPENROUTER_API_KEY:-}" \
  "${DEFAULT_MODEL:-google/gemini-2.0-flash-exp:free}" \
  > "$HOME/.config/opencode/opencode.jsonc"

echo "[opencode-gateway] config written — model: openrouter/${DEFAULT_MODEL:-google/gemini-2.0-flash-exp:free}"
echo "[opencode-gateway] starting supergateway on :8000"

exec supergateway --stdio "opencode-mcp" --port 8000 --cors

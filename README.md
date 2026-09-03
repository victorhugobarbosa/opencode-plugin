# opencode-plugin

Claude Code plugin para delegação de tarefas ao OpenCode com model rotation via OpenRouter.

## Arquitetura

```
Claude Code (local) → MCP SSE → supergateway (VPS) → opencode-mcp → OpenCode agent
                                                                      ↓
                                                         OpenRouter free models (auto-rotate)
```

## Instalação do Plugin

### 1. Adicionar marketplace no `~/.claude/settings.json`

```json
"extraKnownMarketplaces": {
  "opencode-plugin": {
    "source": {
      "source": "github",
      "repo": "victorhugobarbosa/opencode-plugin"
    }
  }
}
```

### 2. Ativar o plugin

```json
"enabledPlugins": {
  "opencode-plugin@opencode-plugin": true
}
```

### 3. Adicionar o MCP remoto

No `~/.claude.json` → `mcpServers`:

```json
"opencode-remote": {
  "type": "sse",
  "url": "https://opencode-mcp.seudominio.com/sse"
}
```

## Deploy do Servidor

### Via Dokploy (recomendado)

1. Criar compose no Dokploy com o conteúdo de `docker-compose.yml`
2. Adicionar env var `OPENROUTER_API_KEY`
3. Configurar domínio + SSL via Traefik
4. Deploy

### Local (dev/teste)

```bash
OPENROUTER_API_KEY=sk-or-... docker compose up
# MCP disponível em: http://localhost:8000/sse
```

## Configuração de Modelos

Altere via env var `DEFAULT_MODEL` (padrão: `google/gemini-2.0-flash-exp:free`).

### Modelos gratuitos via OpenRouter

| Modelo | Velocidade | Qualidade |
|--------|-----------|-----------|
| `google/gemini-2.0-flash-exp:free` | Rápido | Boa |
| `google/gemini-2.5-flash:free` | Rápido | Melhor |
| `meta-llama/llama-3.3-70b-instruct:free` | Médio | Boa |
| `mistralai/mistral-7b-instruct:free` | Rápido | Básica |

## Skills disponíveis

- **`delegate`** — Delegar task ao OpenCode (instrução de uso)

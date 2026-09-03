FROM node:22-alpine

WORKDIR /app

# supergateway: stdio→SSE bridge | opencode-mcp: wraps OpenCode HTTP server
RUN npm install -g supergateway opencode-mcp

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]

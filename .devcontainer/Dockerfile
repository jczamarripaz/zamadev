FROM mcr.microsoft.com/devcontainers/javascript-node:20-bookworm

RUN apt-get update && apt-get install -y gh \
    && npm install -g @angular/cli@21.1.3

RUN apt-get update && apt-get install -y procps

RUN mkdir -p /workspaces/zamadev/node_modules && chown -R node:node /workspaces/zamadevngs
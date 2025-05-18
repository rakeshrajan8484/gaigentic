#!/usr/bin/env bash
#
# launch.sh – one‑command installer/runner for the “Gaigentic” stack
# Repository: https://github.com/rakeshrajan8484/gaigentic
# Works on macOS, Linux, WSL, Git Bash, and other Bash‑capable shells.
# Prerequisite: Docker Engine or Docker Desktop with Compose v2.
#
set -euo pipefail

REPO_URL="https://github.com/rakeshrajan8484/gaigentic.git"
CLONE_DIR="$HOME/.gaigentic"

info () { printf "\033[1;34m▶ %s\033[0m\n" "$*"; }
warn () { printf "\033[1;33mℹ️  %s\033[0m\n" "$*"; }
error() { printf "\033[1;31m❌ %s\033[0m\n" "$*"; exit 1; }

# 1. Check Docker/Compose
if ! docker compose version >/dev/null 2>&1; then
  error "Docker Compose v2 not found. Install Docker Desktop (macOS/Windows) or Docker Engine + compose plugin."
fi
info "Docker Compose found: $(docker compose version --short)"

# 2. Clone or update the repo
if [ -d "$CLONE_DIR/.git" ]; then
  info "Updating existing clone in $CLONE_DIR"
  git -C "$CLONE_DIR" pull --quiet
else
  info "Cloning Gaigentic repo into $CLONE_DIR"
  git clone --quiet --depth 1 "$REPO_URL" "$CLONE_DIR"
fi

cd "$CLONE_DIR"

# 3. Handle environment file
if [ -f .env.example ] && [ ! -f .env ]; then
  cp .env.example .env
  warn "Created $CLONE_DIR/.env from template. Edit it to set secrets or custom values."
fi

# 4. Pull images referenced in docker‑compose.yml
info "Pulling container images (this may take a minute)…"
docker compose pull

# 5. Start services
info "Starting Gaigentic stack…"
docker compose up -d

info "Stack is running! Current service status:"
docker compose ps --all

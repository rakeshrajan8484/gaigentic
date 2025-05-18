#!/usr/bin/env bash
#
# launch.sh – One‑command installer/runner for “My Stack”
# Works on Linux, macOS, WSL, and Windows PowerShell via `bash`
#
set -euo pipefail

REPO="https://github.com/your‑org/my‑stack.git"
CLONE_DIR="${HOME}/.my‑stack"      # persistent location for volumes/logs

echo "▶ Checking Docker/Compose …"
if ! docker compose version >/dev/null 2>&1; then
  echo "❌ Docker Compose v2 not found. Install Docker Desktop or the compose plugin." >&2
  exit 1
fi

# Clone or update
if [ -d "$CLONE_DIR/.git" ]; then
  echo "▶ Updating existing clone in $CLONE_DIR"
  git -C "$CLONE_DIR" pull --quiet
else
  echo "▶ Cloning $REPO into $CLONE_DIR"
  git clone --quiet --depth 1 "$REPO" "$CLONE_DIR"
fi

cd "$CLONE_DIR"

# Copy env template if user hasn’t created one
if [ -f .env.example ] && [ ! -f .env ]; then
  cp .env.example .env
  echo "ℹ️  Edit $CLONE_DIR/.env to set secrets or custom values."
fi

echo "▶ Pulling images …"
docker compose pull

echo "▶ Starting services …"
docker compose up -d

echo "✅ Stack is running!"
docker compose ps

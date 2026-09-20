#!/usr/bin/env bash
# ============================================================
# deploy.sh — pull latest, rebuild, and health-check the
# portfolio container on the home server.
#
# Usage:  ./deploy.sh
# ============================================================
set -euo pipefail

# --- Config ---
HOST_PORT="8088"                 # host port mapped in docker-compose.yml
HEALTH_URL="http://localhost:${HOST_PORT}"
SERVICE="portfolio"

# Resolve repo dir (dir this script lives in) so it works from anywhere
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

log()  { printf '\033[0;36m[deploy]\033[0m %s\n' "$*"; }
fail() { printf '\033[0;31m[deploy] ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# --- Pick docker compose command (v2 plugin vs legacy) ---
if docker compose version >/dev/null 2>&1; then
  COMPOSE="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE="docker-compose"
else
  fail "Docker Compose not found. Install Docker + Compose plugin first."
fi

# --- 1. Pull latest code ---
log "Fetching latest from git..."
BEFORE="$(git rev-parse HEAD)"
git pull --ff-only
AFTER="$(git rev-parse HEAD)"

if [[ "$BEFORE" == "$AFTER" ]]; then
  log "Already up to date ($AFTER). Rebuilding anyway to be safe."
else
  log "Updated ${BEFORE:0:7} -> ${AFTER:0:7}."
fi

# --- 2. Build and (re)start ---
log "Building and starting container..."
$COMPOSE up -d --build

# --- 3. Prune old dangling images to save disk ---
log "Pruning dangling images..."
docker image prune -f >/dev/null 2>&1 || true

# --- 4. Health check ---
log "Waiting for ${SERVICE} to respond at ${HEALTH_URL}..."
for i in $(seq 1 15); do
  if curl -fsS -o /dev/null "$HEALTH_URL"; then
    log "Healthy ✅  ($HEALTH_URL returned 200)"
    log "Deploy complete."
    exit 0
  fi
  sleep 2
done

# --- Failure path: show logs to aid debugging ---
fail "Health check failed after ~30s. Recent logs:
$($COMPOSE logs --tail=30 "$SERVICE" 2>&1)"

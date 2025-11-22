#!/bin/bash
set -e

CLEAN=false
GO=false

# Parse args
for arg in "$@"; do
  case $arg in
    --clean)
      CLEAN=true
      ;;
    --go)
      GO=true
      ;;
  esac
done

if [ "$CLEAN" = true ]; then
  echo "🚨 CLEAN start: removing containers and volumes..."
  docker compose down -v --remove-orphans
  echo "🔨 Rebuilding images..."
  docker compose build
  echo "🚀 Starting containers..."
  docker compose up -d
elif [ "$GO" = true ]; then
  echo "♻️ Restarting app container..."
  docker compose up -d
else
  echo "🚀 Starting containers (no clean)..."
  docker compose up -d
fi

echo "⏳ Waiting for Rails to boot..."
sleep 2

echo "📡 Streaming logs (CTRL+C to stop)"
docker compose logs -f app

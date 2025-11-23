#!/bin/bash
set -e

CLEAN=false

# Parse args
for arg in "$@"; do
  case $arg in
    --clean)
      CLEAN=true
      shift
      ;;
  esac
done

if [ "$CLEAN" = true ]; then
  echo "🚨 CLEAN mode: removing containers, volumes, and DB..."

  docker compose down -v --remove-orphans
  docker compose build

  echo "🚀 Starting containers..."
  docker compose up -d
else
  echo "🚀 Starting containers (no clean)..."
  docker compose up -d
fi

echo "⏳ Waiting for PostgreSQL..."
docker compose exec db bash -c "
  max_attempts=20
  attempt=1
  until pg_isready -h localhost -p 5432 -U postgres; do
    if [ \$attempt -ge \$max_attempts ]; then
      echo 'Postgres did not become ready in time, exiting.'
      exit 1
    fi
    echo \"Still waiting... (\$attempt/\$max_attempts)\"
    attempt=\$((attempt+1))
    sleep 2
  done
"

if [ "$CLEAN" = true ]; then
  echo "🗑 Dropping & recreating DB..."
  docker compose exec app bash -c "bin/rails db:reset"
fi

echo "✅ Environment ready"

echo "🐚 Opening shell in app container..."
docker compose exec app bash

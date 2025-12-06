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
  echo "[CLEAN] removing containers, volumes, and DB..."

  docker compose down -v --remove-orphans
  docker compose build

  echo "[BOOT] Starting containers..."
  docker compose up -d
else
  echo "[BOOT] Starting containers (no clean)..."
  docker compose up -d
fi

echo "[WAIT] Waiting for PostgreSQL..."
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
  echo "[DB] Dropping & recreating DB (RAILS_ENV=test)..."
  docker compose exec -e RAILS_ENV=test app bash -c "bin/rails db:reset"
fi

echo "[OK] Environment ready"

echo "[SHELL] Opening shell in app container (RAILS_ENV=test)..."
docker compose exec -e RAILS_ENV=test app bash -c "export RAILS_ENV=test; exec bash"

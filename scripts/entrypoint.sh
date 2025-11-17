#!/bin/bash
set -e

echo "Waiting for PostgreSQL..."
max_attempts=20
attempt=1

until pg_isready -h db -p 5432 -U postgres; do
  if [ $attempt -ge $max_attempts ]; then
    echo "Postgres did not become ready in time, exiting."
    exit 1
  fi
  echo "Still waiting... ($attempt/$max_attempts)"
  attempt=$((attempt+1))
  sleep 2
done

echo "Database ready, running migrations..."
bin/rails db:create db:migrate

echo "Starting Rails server..."
exec bin/rails server -b 0.0.0.0

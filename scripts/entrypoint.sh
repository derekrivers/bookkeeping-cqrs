#!/bin/bash
set -e

echo "Waiting for PostgreSQL..."
until pg_isready -h db -p 5432; do
  sleep 2
done

echo "Database ready, running migrations..."
bin/rails db:create db:migrate

echo "Starting Rails server..."
exec bin/rails server -b 0.0.0.0

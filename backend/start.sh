#!/bin/sh

set -e

# Wait for the database to be ready before starting the application
/app/wait-for.sh postgres:5432 -t 0 -- echo "Database is ready, starting app..."

exec "$@"

#!/usr/bin/env bash
set -e

# This has relatively little cost and allows for dynamic reloading when only the Gemfile changes
echo "Running bundle install..."
bundle install

if [ -n "${POSTGRES_HOST:-}" ]; then
  echo "Waiting for Postgres at $POSTGRES_HOST..."
  until pg_isready -h "$POSTGRES_HOST" -U "${POSTGRES_USER:-postgres}" >/dev/null 2>&1; do
    sleep 1
  done
fi

if [ -n "${MYSQL_HOST:-}" ]; then
  echo "Waiting for MySQL at $MYSQL_HOST..."
  until mysqladmin ping -h"$MYSQL_HOST" -u"${MYSQL_USER:-root}" -p"${MYSQL_PASSWORD:-root}" --silent; do
    sleep 1
  done
fi

echo "Running mysql db:prepare..."
bundle exec rails db:prepare

echo "Running postgres db:prepare..."
DB_MODE=postgres bundle exec rails db:prepare

echo "Running datadog-agent start and ignoring failures..."
service datadog-agent start || true

echo "Starting app..."
exec "$@"

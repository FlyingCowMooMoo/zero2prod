!/usr/bin/env bash
set -x
set -eo pipefail

DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=newsletter}"
DB_PORT="${POSTGRES_PORT:=5432}"
export PG_HOST="$(/sbin/ip route|awk '/default/ { print $3 }')"

export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${PG_HOST}:${DB_PORT}/${DB_NAME}
sqlx migrate run
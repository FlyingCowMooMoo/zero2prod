!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v sqlx)" ]; then
    echo >&2 "Error: sqlx is not installed."
    echo >&2 "Use:"
    echo >&2 " cargo install --version=0.5.7 sqlx-cli --no-default-features --features postgres"
    echo >&2 "to install it."
    exit 1
fi

if [ -z "$1" ]
  then
    echo "No argument supplied"
fi


DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=newsletter}"
DB_PORT="${POSTGRES_PORT:=5432}"
export PG_HOST="$(/sbin/ip route|awk '/default/ { print $3 }')"

export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${PG_HOST}:${DB_PORT}/${DB_NAME}
sqlx migrate add "$1"
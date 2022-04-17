!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
    echo >&2 "Error: psql is not installed."
    exit 1
fi

DB_USER=${POSTGRES_USER:=postgres}
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=newsletter}"
DB_PORT="${POSTGRES_PORT:=5432}"

if [ `docker ps | grep -q postgres` ]; then
    SKIP_DOCKER=true
fi

if [[ -z "${SKIP_DOCKER}" ]]
then
    echo "SKIP_DOCKER is ${SKIP_DOCKER}!"
    docker run \
    -e POSTGRES_USER=${DB_USER} \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    -e POSTGRES_DB=${DB_NAME} \
    -p "${DB_PORT}":5432 \
    -d postgres \
    postgres -N 1000
fi

export PG_HOST="$(/sbin/ip route|awk '/default/ { print $3 }')"
export PGPASSWORD="${DB_PASSWORD}"
until psql -h "${PG_HOST}" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
    >&2 echo "Postgres is still unavailable - sleeping"
    sleep 1
done
echo "Postgres is up and running on port ${DB_PORT}!"
export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${PG_HOST}:${DB_PORT}/${DB_NAME}

echo "Postgres is up and running at ${PG_HOST}:${DB_PORT} - running migrations now!"


sqlx database create
sqlx migrate run

echo "Postgres has been migrated, ready to go!"
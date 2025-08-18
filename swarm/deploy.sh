#!/usr/bin/env bash
cd "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")" || return 1

set -a
source .env
set +a

cp -f ../common/patched-entrypoint.sh ./patched-entrypoint.sh
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-action-runner-in-docker}"

mkdir -p ./cache-data

docker stack deploy -c docker-compose.yml "${COMPOSE_PROJECT_NAME:-action-runner-in-docker}"
#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")" || return 1

SCALE="${SCALE:-1}"
WITH_DOCKER_SOCKET="${WITH_DOCKER_SOCKET:-false}"
COMPOSE_FILE=("-f" "docker-compose.yml")

if [ -z "$ACCESS_TOKEN" ]; then
    echo "Empty ACCESS_TOKEN"
    exit 1
fi

if [ -z "$ORG_NAME" ]; then
    echo "Empty ORG_NAME"
    exit 1
fi

if [ "$WITH_DOCKER_SOCKET" = true ]; then
    COMPOSE_FILE+=("-f" "docker-compose.with-docker-socket.yml")
    echo "Setting with docker socket..."
fi

###############################################################

export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-action-runner-in-docker}"

function EXIT() {
    kill "$PID" 2>/dev/null || true
    echo "Stopping Daemon..."
    docker compose down
}

function MAIN() {
    trap 'exit 0' SIGINT SIGTERM SIGALRM
    
    echo "Starting Daemon..."
    while true; do
        local current_count="$(docker compose "${COMPOSE_FILE[@]}" ps -q | wc -l)"
        if [ "$current_count" -lt "$SCALE" ]; then
            echo "Current runner count ($current_count) is less than desired scale ($SCALE). Scaling up..."
            docker compose rm -f github-runner 2>/dev/null
            docker compose "${COMPOSE_FILE[@]}" up -d --scale github-runner="$SCALE" 2>&1 | grep -E 'Creating|Recreating|Restarting'
        fi
        sleep 1
    done
}

trap EXIT SIGINT SIGTERM SIGALRM

MAIN "$@" &
PID="$!"
wait "$PID"
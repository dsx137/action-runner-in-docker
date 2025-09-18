#!/usr/bin/env bash

PIDS=()

function EXIT() {
    echo "Stopping all services..."
    for pid in "${PIDS[@]}"; do
        kill -s "$1" "$pid" 2>/dev/null || true
    done
    wait "${PIDS[@]}" 2>/dev/null || true
    echo "All services stopped."
}

trap 'EXIT SIGINT' SIGINT
trap 'EXIT SIGTERM' SIGTERM
trap 'EXIT SIGALRM' SIGALRM

for service in /etc/service/*; do
    if [ -d "$service" ]; then
        echo "Starting service: $(basename "$service")"
        /etc/service/"$(basename "$service")"/run &
        PIDS+=("$!")
    fi
done

wait "${PIDS[@]}"

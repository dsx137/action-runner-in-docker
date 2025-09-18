#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")" || return 1

systemctl stop action-runner-in-docker.service
systemctl disable action-runner-in-docker.service

rm -f /etc/systemd/system/action-runner-in-docker.service

echo "Action Runner in Docker service has been disabled and stopped."
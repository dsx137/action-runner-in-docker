#!/usr/bin/env bash

cd "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")" || return 1

cp ./action-runner-in-docker.service /etc/systemd/system/action-runner-in-docker.service
systemctl daemon-reload
systemctl enable action-runner-in-docker.service
systemctl start action-runner-in-docker.service

echo "Action Runner in Docker service has been set up and started."
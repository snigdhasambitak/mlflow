#!/bin/bash

BASE_DIR=$(dirname "${BASH_SOURCE:-0}")

docker-compose -f "${BASE_DIR}"/../docker-compose.yaml down

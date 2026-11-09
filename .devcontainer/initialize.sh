#!/usr/bin/env bash
set -euo pipefail

# Ensure we have the root .env file
test -f .env || cp sample-env.txt .env

# Ensure we have the docker-compose customisation file
test -f .devcontainer/docker-compose.personal.yml || cp .devcontainer/docker-compose.personal.template.yml .devcontainer/docker-compose.personal.yml

env_file=.devcontainer/.env
touch "$env_file"

# Expose different ports for each container
if ! grep -q '^DEVSERVER_PORT=' "$env_file"; then
  # Collect ports already claimed by the other worktrees
  used=$(git worktree list --porcelain \
    | sed -n 's/^worktree //p' \
    | while read -r d; do grep -hs '^DEVSERVER_PORT=' "$d/.devcontainer/.env" || true; done \
    | cut -d= -f2)
  port=8001
  while grep -qx "$port" <<<"$used"; do port=$((port + 1)); done
  {
    echo "DEVSERVER_PORT=$port"
    echo "INSTANCE_NAME=$(basename "$PWD")"
  } >> "$env_file"
fi

# Determine the root worktree directory
sed -i '/^WORKTREE_DIR=/d;/^GIT_COMMON_DIR=/d' "$env_file"
{
  echo "WORKTREE_DIR=$PWD"
  echo "GIT_COMMON_DIR=$(git rev-parse --path-format=absolute --git-common-dir)"
} >> "$env_file"

# This file will load a .env file to allow overriding values.

set dotenv-load := true

# Untracked per-developer files copied from the main worktree into new worktrees
personal_files := ".env .devcontainer/docker-compose.personal.yaml .devcontainer/Dockerfile.personal"

# This list of available targets
default:
    @just --list

# Install python DEV dependancies
install:
    uv sync
    uv run pre-commit install --hook-type pre-commit

# uv run a command
[working-directory: "src"]
run +options:
    uv run {{options}}

# Run the Django manage command
manage +options:
    just run manage.py {{options}}

# Run the makemigrations command
makemigrations +options="":
    just manage makemigrations {{options}}

# Run the database migrations command
migrate +options="":
    just manage migrate {{options}}

# Start the django development server
runserver +options="":
    just manage runserver {{options}}

# Run the Django admin command
django-admin +options:
    uv run django-admin {{options}}

# Run the tests
[working-directory: "src"]
test +options="":
    uv run pytest {{options}}

# Check the code
[working-directory: "src"]
lint:
    uv run ruff check .
    uv run ruff format --check .
    uv run ty check .
    uv run python manage.py check

# Report the current version
version:
    uv version --short

# Run the uv version command
bumpversion +options="":
    uv version {{options}}

# Bump the release candidate
bump_rc +options="":
    uv version --bump rc {{options}}
    git commit -am "Bump version to $(uv version --short)"
    git push

# Start new develpment cycle with new patch and release candidate
bump_patch +options="":
    uv version --bump patch --bump rc {{options}}
    git commit -am "Bump version to $(uv version --short)"
    git push

# Bump the version for a release. Make tag and commit
bump_release +options="":
    uv version --bump stable {{options}}
    git commit -am "Release $(uv version --short)"
    git tag -a "v$(uv version --short)" -m "Release $(uv version --short)"
    git push && git push --tags


# ---- Worktrees and devcontainers (run on the HOST, not in a container) ----

# Copy the personal files from the main worktree to DEST (existing files are kept unless overwrite=true)
[private]
_copy-personal dest overwrite="false":
    #!/usr/bin/env bash
    set -euo pipefail
    main=$(git worktree list --porcelain | sed -n '1s/^worktree //p')
    dest="{{dest}}"
    if [ "$dest" = "$main" ]; then
        echo "Destination is the main worktree" >&2; exit 1
    fi
    for f in {{personal_files}}; do
        if [ ! -f "$main/$f" ]; then
            echo "skip (not in main): $f"; continue
        fi
        if [ -e "$dest/$f" ] && [ "{{overwrite}}" != "true" ]; then
            echo "keep (exists): $f"; continue
        fi
        mkdir -p "$(dirname "$dest/$f")"
        cp -p "$main/$f" "$dest/$f"
        echo "copied: $f"
    done

# Refresh the personal files in an existing worktree from the main worktree
worktree-sync name overwrite="false": _host-only
    #!/usr/bin/env bash
    set -euo pipefail
    path=$(just _worktree-path "{{name}}")
    just _copy-personal "$path" "{{overwrite}}"

# Refuse to run inside a devcontainer
[private]
_host-only:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -f /.dockerenv ]; then
        echo "Run this recipe on the host, not inside a devcontainer" >&2
        exit 1
    fi

# Resolve a branch name (or an absolute path) to a worktree path
[private]
_worktree-path name:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{name}}" in /*) echo "{{name}}"; exit 0 ;; esac
    main=$(git worktree list --porcelain | sed -n '1s/^worktree //p')
    root="${WORKTREE_ROOT:-$(dirname "$main")}"
    echo "$root/$(basename "$main")-$(echo "{{name}}" | tr '/' '-')"

# Remove the devcontainer for a worktree path. purge=true also deletes its volumes
[private]
_dc-down path purge="false":
    #!/usr/bin/env bash
    set -euo pipefail
    path=$(realpath "{{path}}")
    ids=$(docker ps -aq --filter "label=devcontainer.local_folder=$path")
    if [ -z "$ids" ]; then
        echo "No devcontainer found for $path"
        exit 0
    fi
    project=$(docker inspect -f '{{{{index .Config.Labels "com.docker.compose.project"}}' $(echo "$ids" | head -1))
    docker compose -p "$project" down --remove-orphans
    if [ "{{purge}}" = "true" ]; then
        # Never delete the shared caches
        docker volume ls -q --filter "label=com.docker.compose.project=$project" \
            | { grep -v '^shared-' || true; } \
            | xargs -r docker volume rm
    fi

# Start the devcontainer for a worktree (default: this one)
dc-up path=justfile_directory(): _host-only
    devcontainer up --workspace-folder "{{path}}" </dev/null

# Remove the devcontainer for a worktree, keeping its volumes (default: this one)
dc-down path=justfile_directory(): _host-only
    just _dc-down "{{path}}" false

# Start the devcontainers for every worktree, one at a time
dc-up-all: _host-only
    #!/usr/bin/env bash
    set -euo pipefail
    git worktree list --porcelain | sed -n 's/^worktree //p' | while read -r wt; do
        devcontainer up --workspace-folder "$wt" </dev/null
    done

# Remove the devcontainers for every worktree, keeping volumes
dc-down-all: _host-only
    #!/usr/bin/env bash
    set -euo pipefail
    git worktree list --porcelain | sed -n 's/^worktree //p' | while read -r wt; do
        just _dc-down "$wt" false </dev/null
    done

# Show the worktrees
worktree-list:
    git worktree list

# Add a worktree for BRANCH (created from BASE if new) and start its devcontainer
worktree-add branch base="HEAD" up="true": _host-only
    #!/usr/bin/env bash
    set -euo pipefail
    path=$(just _worktree-path "{{branch}}")
    if git show-ref --verify --quiet "refs/heads/{{branch}}"; then
        git worktree add "$path" "{{branch}}"
    else
        git worktree add -b "{{branch}}" "$path" "{{base}}"
    fi
    just _copy-personal "$path"
    if [ "{{up}}" = "true" ]; then
        devcontainer up --workspace-folder "$path" </dev/null
    fi
    echo "Worktree ready: $path"

# Remove a worktree and its devcontainer. force=true discards uncommitted changes
worktree-remove name force="false" delete_branch="false": _host-only
    #!/usr/bin/env bash
    set -euo pipefail
    path=$(just _worktree-path "{{name}}")
    main=$(git worktree list --porcelain | sed -n '1s/^worktree //p')

    if [ "$path" = "$main" ]; then
        echo "Refusing to remove the main worktree" >&2; exit 1
    fi
    if ! git worktree list --porcelain | grep -qx "worktree $path"; then
        echo "Not a registered worktree: $path" >&2; exit 1
    fi
    case "{{invocation_directory()}}/" in
        "$path"/*) echo "You are inside $path - run this from another worktree" >&2; exit 1 ;;
    esac
    if [ "{{force}}" != "true" ] && [ -n "$(git -C "$path" status --porcelain)" ]; then
        echo "Uncommitted changes in $path - commit them or pass force=true" >&2; exit 1
    fi

    branch=$(git -C "$path" symbolic-ref --short -q HEAD || true)

    just _dc-down "$path" true
    if [ "{{force}}" = "true" ]; then
        git worktree remove --force "$path"
    else
        git worktree remove "$path"
    fi
    if [ "{{delete_branch}}" = "true" ] && [ -n "$branch" ]; then
        git branch -d "$branch"
    fi
    echo "Removed $path"

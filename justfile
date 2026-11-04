# This file will load a .env file to allow overriding values.

set dotenv-load := true

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

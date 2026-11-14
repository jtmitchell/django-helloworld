# syntax=docker.io/docker/dockerfile:1.7-labs
# Allows use of --exclude in the COPY

# ---
# Base linux layer
# ---
FROM ubuntu:26.04 AS linux-base

# Assure UTF-8 encoding is used.
ENV LC_CTYPE=C.utf8
# Location of the virtual environment
ENV UV_PROJECT_ENVIRONMENT="/venv"
# Location of the python installation via uv
ENV UV_PYTHON_INSTALL_DIR="/python"
# Byte compile the python files on installation
ENV UV_COMPILE_BYTECODE=1
# Python version to use
ENV UV_PYTHON=python3.14
# Tweaking the PATH variable for easier use
ENV PATH="$UV_PROJECT_ENVIRONMENT/bin:$PATH"

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates \
    && rm -rf /var/lib/apt/lists/*
# ---
# Base Python install
# ---
FROM linux-base AS python-base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /var/app

# Create virtual environment and install dependencies
COPY pyproject.toml uv.lock /var/app/
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# ---
# Install the Python app
# ---
FROM python-base AS builder-base

WORKDIR /var/app

COPY src/ /var/app/

# collectstatic must not require a live DB connection or real secrets.
RUN DJANGO_SETTINGS_MODULE="helloworld.settings" \
    SECRET_KEY=notsecret \
    uv run --no-sync python /var/app/manage.py collectstatic --no-input

# ---
# Development container image
# ---
FROM builder-base AS development

RUN apt-get update \
    && apt-get install --no-install-recommends -y gettext \
    && rm -rf /var/lib/apt/lists/*

# Install the development packages
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project

WORKDIR /var/app
EXPOSE 8000 5678

# Add "--wait-for-client" if the runserver should wait for a client to attach before running
CMD ["python", "-m",  "debugpy", "--listen", "0.0.0.0:5678", "manage.py", "runserver", "0.0.0.0:8000"]

# ---
# Production container image
# ---
FROM linux-base AS production

RUN groupadd --system app && useradd --system --gid app --no-create-home app

# Copy python, virtual env and static assets.
COPY --from=builder-base $UV_PYTHON_INSTALL_DIR $UV_PYTHON_INSTALL_DIR
COPY --from=builder-base $UV_PROJECT_ENVIRONMENT $UV_PROJECT_ENVIRONMENT
COPY --from=builder-base --exclude=uv.lock /var/app /var/app

WORKDIR /var/app
USER app
EXPOSE 8000

# Migrations run from a separate sidecar/job, not here.
# Exec form - granian runs as PID 1 directly, no shell involved.
# workers/threads etc set for Cloud Run. Check against cloud run "--concurrency"
CMD ["granian", "helloworld.wsgi:application", \
    "--host", "0.0.0.0", \
    "--port", "8000", \
    "--interface", "wsgi", \
    "--no-ws", \
    "--loop", "uvloop", \
    "--workers", "1", \
    "--blocking-threads", "8", \
    "--backpressure", "16", \
    "--process-name", "granian [helloworld]"]

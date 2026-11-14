ARG UV_VERSION=latest

FROM ghcr.io/astral-sh/uv:$UV_VERSION AS uv

FROM mcr.microsoft.com/devcontainers/python:3.14

ENV PYTHONDONTWRITEBYTECODE=True \
    PYTHONUNBUFFERED=True \
    UV_LINK_MODE=copy \
    UV_CACHE_DIR=/home/vscode/.cache/uv \
    PRE_COMMIT_HOME=/home/vscode/.cache/pre-commit \
    PRE_COMMIT_USE_UV=1 \
    VIRTUAL_ENV=/workspace/.venv \
    PATH=/workspace/.venv/bin:$PATH

COPY --from=uv --chown=vscode: /uv /uvx /bin/

# Pre-create mount points owned by vscode so new named volumes inherit ownership
RUN mkdir -p /workspace/.venv /home/vscode/.cache/uv /home/vscode/.cache/pre-commit \
    && chown -R vscode: /workspace/.venv /home/vscode/.cache

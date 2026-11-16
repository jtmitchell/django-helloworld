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

# ---------------------------------------------------------------------------
# Login shells (VS Code terminals, the env probe, gh codespace ssh) source
# /etc/profile, which resets PATH. The base image restores only the PATH it
# had when it was built, so the ENV line above is lost. Put it back.
# ---------------------------------------------------------------------------
RUN printf '%s\n' \
    'case ":$PATH:" in *":/workspace/.venv/bin:"*) ;; *) export PATH="/workspace/.venv/bin:$PATH" ;; esac' \
    > /etc/profile.d/10-venv.sh

# ---------------------------------------------------------------------------
# Tool versions - bump these deliberately (changing a value rebuilds that layer)
# ---------------------------------------------------------------------------
ARG AZURE_CLI_VERSION=2.88.0
ARG KUBECTL_VERSION=v1.37.2
ARG TERRAFORM_VERSION=1.16.5
# "latest" follows the newest GitHub release; set e.g. v0.50.0 to pin
ARG K9S_VERSION=latest

# ---------------------------------------------------------------------------
# Azure CLI
# Installed from PyPI with uv, because Microsoft's apt repo has no Debian
# trixie release and Debian's own azure-cli package pulls in ~250 packages.
# - explicit interpreter path, so the (empty) /workspace/.venv is never used
# - --no-cache, so no root-owned files land in the vscode uv cache mount point
# - UV_COMPILE_BYTECODE, because PYTHONDONTWRITEBYTECODE is set above and az
#   is slow to start without .pyc files
# ---------------------------------------------------------------------------
RUN UV_TOOL_DIR=/opt/uv-tools \
    UV_TOOL_BIN_DIR=/usr/local/bin \
    UV_COMPILE_BYTECODE=1 \
    uv tool install \
        --no-cache \
        --no-managed-python \
        --python /usr/local/bin/python3.14 \
        "azure-cli==${AZURE_CLI_VERSION}"

# ---------------------------------------------------------------------------
# kubectl (checksum verified against the published .sha256 file)
# ---------------------------------------------------------------------------
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    cd /tmp; \
    curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${arch}/kubectl"; \
    curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${arch}/kubectl.sha256"; \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check; \
    install -m 0755 kubectl /usr/local/bin/kubectl; \
    rm -f kubectl kubectl.sha256

# ---------------------------------------------------------------------------
# Terraform (checksum verified against HashiCorp's SHA256SUMS file)
# python -m zipfile is used for extraction, so no extra apt packages are needed
# ---------------------------------------------------------------------------
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    zip="terraform_${TERRAFORM_VERSION}_linux_${arch}.zip"; \
    base="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}"; \
    cd /tmp; \
    curl -fsSLO "${base}/${zip}"; \
    curl -fsSLO "${base}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"; \
    grep " ${zip}\$" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum --check; \
    python3 -m zipfile -e "${zip}" /tmp/terraform-extract; \
    install -m 0755 /tmp/terraform-extract/terraform /usr/local/bin/terraform; \
    rm -rf "${zip}" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" /tmp/terraform-extract

# ---------------------------------------------------------------------------
# k9s
# ---------------------------------------------------------------------------
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    if [ "${K9S_VERSION}" = "latest" ]; then \
        url="https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${arch}.tar.gz"; \
    else \
        url="https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${arch}.tar.gz"; \
    fi; \
    curl -fsSL "${url}" | tar -xz -C /usr/local/bin k9s; \
    chmod 0755 /usr/local/bin/k9s

# Cheap smoke test so a broken download fails the build, not your first command
# (az is skipped here on purpose: it is slow to start and writes ~/.azure)
RUN test -x /usr/local/bin/az \
    && kubectl version --client \
    && terraform version \
    && k9s version

# `helloworld` Demo Django Website

A sample django website for a presentation on using containers with Python development.

# Production Environment

Assume that the project has now been deployed into a cloud environment, and is running with
- A [Postgres](https://www.postgresql.org/) database
- A redis compatible [valkey](https://valkey.io/) cache

The project running as a container that we build somewhere else.

As an example, if the project is running on an Azure managed-Kubernetes cluster, the developer may now be expected to use the following tools to manage the app
- `az` cli to login to the Azure services
- `kubectl` for interacting with the Kubernetes cluster

# Branch Status

The branch adds personalisation to the devcontainer, so developers can add their preferred LLM agents.

It also adds some automation commands to help with using [git worktrees](https://git-scm.com/docs/git-worktree)
and parallel development on a single laptop.

# Developer Onboarding

New developers are expected to handle installation of external tools for their own system.
If they are working inside a cloud editor, the git and devcontainer tools will already be provided.

## External tools
- [git](https://git-scm.com/)
- [devcontainer](https://containers.dev/)
- Their preferred code editor
- [Docker](https://www.docker.com/) or [podman](https://podman.io/) to build and run containers

## Tools inside the devcontainer
- [uv](https://docs.astral.sh/uv/)
- [just](https://github.com/casey/just)
- Developer's preferred LLM agent harness
- postgres
- valkey
- [az](https://learn.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)


## Python managed dependancies

These are the major project dependancies, managed by `uv`.
- [Django](https://www.djangoproject.com/)
- [pre-commit](https://pre-commit.com/)
  - this brings in it's own dependancies, including [bandit](https://bandit.readthedocs.io/en/latest/)
- [pytest](https://docs.pytest.org/en/stable/)
- [ruff](https://docs.astral.sh/ruff/)
- [ty](https://docs.astral.sh/ty/)
- [granian](https://pypi.org/project/granian/2.2.1/)
- [redis](https://pypi.org/project/redis/)
- [psycopg2](https://pypi.org/project/psycopg2/)
- [whitenoise](https://pypi.org/project/whitenoise/)
- [tzdata](https://pypi.org/project/tzdata/)

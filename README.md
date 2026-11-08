# `helloworld` Demo Django Website

A sample django website for a presentation on using containers with Python development.

# Production Environment

Assume that the project has now been deployed into a cloud environment, and is running with
- A [Postgres](https://www.postgresql.org/) database
- A redis compatible [valkey](https://valkey.io/) cache

The project running as a container that we build somewhere else.

As an example, if the project is running on an Azure managed-Kubernetes cluster, the developer may now be expected to use the following tools to manage the app
- `az` cli to login to the Azure services
- `terraform` as tool that creates and updates servers and databases in the cloud environment
- `kubectl` and `k9s` tools for interacting with the Kubernetes cluster

# Branch Status

The branch introduces a [Dockerfile](./Dockerfile) that builds the container image.
It also has a [docker compose](./docker-compose.yaml) file that starts production-like services for the app to connect to.
- postgres database
- valkey cache
- email capture

The GitHub workflow now also starts a database and cache, so the tests run against the same services.

# Developer Onboarding

New developers are expected to handle installation of external tools for their own system.

## External tools
- [git](https://git-scm.com/)
- [uv](https://docs.astral.sh/uv/)
- [just](https://github.com/casey/just)
- Their preferred code editor
- ~~A database~~. Handled by docker compose
- ~~A cache~~. Handled by docker compose
- [Docker](https://www.docker.com/) or [podman](https://podman.io/) to build and run containers
- Cloud management tools
  - [az](https://learn.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
  - [terraform](https://developer.hashicorp.com/terraform)
  - [kubectl](https://kubernetes.io/docs/reference/kubectl/)
  - [k9s](https://k9scli.io/)

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

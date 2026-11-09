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

The branch introduces a [devcontainer](https://containers.dev/) and removes the previous docker-compose workflow.

Developers are encouraged to work inside the container where the tools and services are provided.

# Developer Onboarding

New developers are expected to handle installation of external tools for their own system.
If they are working inside a cloud editor, the git and devcontainer tools will already be provided.

## External tools
- [git](https://git-scm.com/)
- [devcontainer](https://containers.dev/)
- ~~[uv](https://docs.astral.sh/uv/)~~ Provided inside the container
- ~~[just](https://github.com/casey/just)~~ Provided inside the container
- Their preferred code editor
- ~~A database~~. Handled by docker compose
- ~~A cache~~. Handled by docker compose
- [Docker](https://www.docker.com/) or [podman](https://podman.io/) to build and run containers
- Cloud management tools
  - ~~[az](https://learn.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)~~ Provided inside the container
  - ~~[terraform](https://developer.hashicorp.com/terraform)~~ Provided inside the container
  - ~~[kubectl](https://kubernetes.io/docs/reference/kubectl/)~~ Provided inside the container
  - ~~[k9s](https://k9scli.io/)~~ Provided inside the container

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

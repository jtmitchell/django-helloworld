# `helloworld` Demo Django Website

A sample django website for a presentation on using containers with Python development.

# Branch Status

We have added a cache decorator to the view, and that has introduced some complexity.
- the database counter has to run outside of the cached view, so it is now a decorator function.

We also have a GitHub workflow action to run tests.

# Developer Onboarding

New developers are still expected to handle installation of external tools for their own system.

## External tools
- [git](https://git-scm.com/)
- [uv](https://docs.astral.sh/uv/)
- [just](https://github.com/casey/just)
- Their preferred code editor
- A database. This can be sqlite, mysql, postgres - anything really
- A cache. Django will default to a file-based cache

## Python managed dependancies

These are the major project dependancies, managed by `uv`.
- [Django](https://www.djangoproject.com/)
- [pre-commit](https://pre-commit.com/)
  - this brings in it's own dependancies, including [bandit](https://bandit.readthedocs.io/en/latest/)
- [pytest](https://docs.pytest.org/en/stable/)
- [ruff](https://docs.astral.sh/ruff/)
- [ty](https://docs.astral.sh/ty/)

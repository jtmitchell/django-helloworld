# `helloworld` Demo Django Website

A sample django website for a presentation on using containers with Python development.

# Branch Status

Now the project has an `echo` app with a template and a view, so it can show a **Hello world** page.
- `just run startapp echo`

The view will also increment a counter in a database, for no reason except to justify adding a database.


# Developer Onboarding

New developers are still expected to handle installation of external tools for their own system.

## External tools
- [git](https://git-scm.com/)
- [uv](https://docs.astral.sh/uv/)
- [just](https://github.com/casey/just)
- Their preferred code editor
- A database

## Python managed dependancies

These are the major project dependancies, managed by `uv`.
- [Django](https://www.djangoproject.com/)
- [pre-commit](https://pre-commit.com/)
  - this brings in it's own dependancies, including [bandit](https://bandit.readthedocs.io/en/latest/)
- [pytest](https://docs.pytest.org/en/stable/)
- [ruff](https://docs.astral.sh/ruff/)
- [ty](https://docs.astral.sh/ty/)

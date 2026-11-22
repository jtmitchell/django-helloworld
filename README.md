# `helloworld` Demo Django Website

A sample django website for a presentation on using containers with Python development.

# Branch Status

Now the project has an `echo` app with a template and a view, so it can show a **Hello world** page.
- `just run startapp echo`

The view will also increment a counter in a database, for no reason except to justify adding a database.


# Developer Onboarding

- Install external tools
  - `git`, `uv`, and `just`
- Checkout the code
- Install Python and dependancies
  - `just install`
- Create a `.env` file based on the sample
  - `cp sample-env.txt .env`
- Edit .env as required
- Apply the database migrations
  - `just migrate`
- Start the development server and view the site
  - `just runserver`
  - http://localhost:8000/

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

# `helloworld` Demo Django Website

A sample django website for a presentation on using containers with Python development.

# Branch Status

At this point there is no real code in the project.

We have an "empty" project, where we have run
- `git init`
- `uv init`
- then added Django and some standard development packages, such as `ruff`, `ty`, and `pre-commit`
- `uv run django-admin startproject src/`


# Developer Onboarding

New developers are expected to handle installation of external tools for their own system.

## External tools
- [git](https://git-scm.com/)
- [uv](https://docs.astral.sh/uv/)
- [just](https://github.com/casey/just)
- Their preferred code editor, such as
  - [vscode](https://code.visualstudio.com/)
  - [pycharm](https://www.jetbrains.com/pycharm/)
  - [zed](https://zed.dev/)
  - [neovim](https://neovim.io/)
  - [helix](https://helix-editor.com/)

## Python managed dependancies

These are the major project dependancies, managed by `uv`.
- [Django](https://www.djangoproject.com/)
- [pre-commit](https://pre-commit.com/)
  - this brings in it's own dependancies, including [bandit](https://bandit.readthedocs.io/en/latest/)
- [pytest](https://docs.pytest.org/en/stable/)
- [ruff](https://docs.astral.sh/ruff/)
- [ty](https://docs.astral.sh/ty/)

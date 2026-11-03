import os
import sys


def django_manage() -> None:
    """Manage.py entrypoint for packaging script."""
    _ = os.environ.setdefault("DJANGO_SETTINGS_MODULE", "helloworld.settings")
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)

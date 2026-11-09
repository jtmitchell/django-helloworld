# yourapp/context_processors.py
from __future__ import annotations

from typing import TYPE_CHECKING

from django.conf import settings

if TYPE_CHECKING:
    from django.http import HttpRequest


def instance(_: HttpRequest) -> dict[str, str]:
    """Expose the dev instance name to templates."""
    return {"instance_name": settings.INSTANCE_NAME if settings.DEBUG else ""}

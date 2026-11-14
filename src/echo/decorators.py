# Define decorators for the views
from __future__ import annotations

import functools
from typing import TYPE_CHECKING

from django.db import IntegrityError, transaction
from django.db.models import F

from . import models

if TYPE_CHECKING:
    from collections.abc import Callable

    from django.http import HttpRequest, HttpResponse


def count_page_view(view: Callable[..., HttpResponse]) -> Callable[..., HttpResponse]:
    """Record a page view on every request, including cache hits.

    This must be applied outside any caching decorator, otherwise a
    cache hit returns before the counter runs.
    """

    @functools.wraps(view)
    def wrapper(request: HttpRequest, *args: object, **kwargs: object) -> HttpResponse:
        match = request.resolver_match
        page_name: str = match.view_name if match else request.path

        # Increment the page views
        try:
            with transaction.atomic():
                models.PageViews.objects.get_or_create(page=page_name, defaults={"page": page_name, "views": 0})
        except IntegrityError:
            # Multiple attempts to create same record, some will raise the exception
            pass
        models.PageViews.objects.filter(page=page_name).update(views=F("views") + 1)

        return view(request, *args, **kwargs)

    return wrapper

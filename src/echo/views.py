# Create your views here.
from typing import TYPE_CHECKING

from django.db import IntegrityError, transaction
from django.db.models import F
from django.shortcuts import render

from . import models

if TYPE_CHECKING:
    from django.http import HttpRequest, HttpResponse


def home(request: HttpRequest) -> HttpResponse:
    """Print hello world."""
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

    return render(request, "echo/home.html", {})

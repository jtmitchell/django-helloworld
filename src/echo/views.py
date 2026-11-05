# Create your views here.
from typing import TYPE_CHECKING

from django.shortcuts import render
from django.views.decorators.cache import cache_page

from .decorators import count_page_view

if TYPE_CHECKING:
    from django.http import HttpRequest, HttpResponse


@count_page_view
@cache_page(60 * 5)
def home(request: HttpRequest) -> HttpResponse:
    """Print hello world."""
    return render(request, "echo/home.html", {})

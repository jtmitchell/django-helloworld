# Create your tests here.
from unittest import mock

import pytest
from django.core.cache import cache
from django.db import IntegrityError

from echo import models


@pytest.mark.django_db
def test_home_increments_views(client):
    client.get("/")
    client.get("/")
    assert models.PageViews.objects.get(page="echo:home").views == 2


@pytest.mark.django_db
def test_cached_hits_are_still_counted(client):
    cache.clear()
    client.get("/")
    client.get("/")  # served from the cache
    assert models.PageViews.objects.get(page="echo:home").views == 2


@pytest.mark.django_db
def test_integrity_error_is_swallowed_and_counted(client):
    models.PageViews.objects.create(page="echo:home", views=5)
    with mock.patch.object(
        models.PageViews.objects,
        "get_or_create",
        side_effect=IntegrityError,
    ):
        client.get("/")
    assert models.PageViews.objects.get(page="echo:home").views == 6

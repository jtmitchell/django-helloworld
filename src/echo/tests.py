# Create your tests here.
import pytest

from echo import models


@pytest.mark.django_db
def test_home_increments_views(client):
    client.get("/")
    client.get("/")
    assert models.PageViews.objects.get(page="echo:home").views == 2

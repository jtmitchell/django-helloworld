from django.urls import path

from . import views

app_name = "echo"

urlpatterns = [
    path("", views.home, name="home"),
]

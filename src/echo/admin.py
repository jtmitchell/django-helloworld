# Register your models here.
from django.contrib import admin

from . import models


@admin.register(models.PageViews)
class PageViewsAdmin(admin.ModelAdmin):
    list_display = ("page", "views")
    search_fields = ("page",)

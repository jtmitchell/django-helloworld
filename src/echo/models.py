# Create your models here.
from django.core.validators import MinValueValidator
from django.db import models
from django.db.models.functions import Lower


class PageViews(models.Model):
    """Count the page views."""

    page = models.CharField(default="", blank=False, null=False, max_length=100)
    views = models.IntegerField(default=0, blank=False, null=False, validators=[MinValueValidator(0)])

    class Meta:
        verbose_name = "Page views"
        ordering = ("page",)
        indexes = [models.Index(fields=["page"])]
        constraints = [models.UniqueConstraint(Lower("page"), name="unique_page_views")]

    def __str__(self) -> str:
        """Record name."""
        return f"{self.page}: {self.views}"

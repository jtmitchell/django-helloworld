# Proposal

## Why

Administrators currently cannot force a cached page response to refresh when they select its `PageViews` record. This action gives them a targeted way to invalidate stale cached content without clearing the shared cache.

## What Changes

- Add a Django admin action to the `PageViews` changelist that invalidates the cached response associated with each selected page record.
- Report completion to the administrator after the action runs.

## Capabilities

### New Capabilities
- `page-cache-invalidation`: Admins can invalidate cached page responses by selecting their `PageViews` records.

### Modified Capabilities

## Impact

- `src/echo/admin.py` and cache invalidation behavior for views served through Django's page cache.
- The in-flight `add-page-greeting` change already defines page-scoped cache generations so greeting edits refresh only the affected page. This admin action should use that same mechanism, allowing administrators to invalidate the selected page's cached response on demand.

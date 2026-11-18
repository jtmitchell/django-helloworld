# Design

## Context

See proposal.md for motivation. `PageViews.page` stores Django route names. The in-flight `add-page-greeting` change replaces opaque `cache_page` keys with a page-scoped cache generation, rotated after a greeting change. The admin action must reuse that page identity and generation so manual invalidation and greeting edits affect the same cache scope.

## Goals / Non-Goals

**Goals:**
- Let an admin invalidate all cached variants belonging to selected page records.
- Keep invalidation isolated from unrelated pages and cached sessions.
- Give the admin action a clear completion result, including when a selected page has no cache entry yet.

**Non-Goals:**
- Change how page views are counted.
- Add a general cache management interface or flush the shared cache.

## Decisions

- Reuse the page-scoped cache generation defined by `add-page-greeting`; do not introduce a second version store or key format. The admin action advances the generation for each selected `PageViews.page`, invalidating all cached variants in that page's scope.
- Use each selected record's page identity directly, matching the greeting change's use of the resolver name. Advancing a generation is safe even when there is no current cache entry; the next response is cached under the current generation.
- Keep the action available in the `PageViews` changelist and use Django admin messaging to summarize the processed selection.
- Alternative considered: clear the default cache. Rejected because it would evict unrelated page responses and potentially cache-backed sessions. Directly deleting a `cache_page` key was also rejected because the route name does not identify its URL, query variants, or vary-header variants.

## Risks / Trade-offs

- [The two changes may be implemented in either order] → Integrate with the generation mechanism from `add-page-greeting` when present; if it is not yet implemented, keep the interface and page identity compatible so only one mechanism is introduced.
- [Version metadata adds a cache lookup to cached responses] → Keep the lookup small and use the configured default cache; the admin action changes only the selected page generations.

# Design

## Context

See `proposal.md` for motivation and `specs/page-greetings/spec.md` for the behavior contract. `count_page_view` identifies pages by resolver name and creates a `PageViews` record before calling the view. The view then runs inside Django's five-minute `cache_page` decorator. That response cache can bypass the database lookup, while `PageViewsAdmin` provides the normal editing path.

## Goals / Non-Goals

**Goals:** Store and render the page-specific greeting, and make an updated greeting visible immediately on the affected page while retaining response caching.

**Non-Goals:** Change page view counting, add cache infrastructure, or introduce user-specific greeting behavior.

## Decisions

- Add a non-null `CharField` named `greeting` with the default `Hi ya!`, and create a Django migration. Existing rows receive the same value through the field default.
- Resolve the current page record by the same resolver name used by `count_page_view`, then pass its greeting to the page template. The child template uses it for the heading, and the base template uses it for the document title.
- Replace the opaque `cache_page` invalidation path with a page-scoped cache generation. Include the page identity and request variation in the response cache key; rotate that page's generation only when its greeting changes. This makes old entries unreachable without clearing unrelated pages or sessions. Keep the existing five-minute response lifetime.
- Detect greeting changes around model saves and rotate the generation after the database save succeeds. Other field updates, including view count increments, do not rotate it.

## Risks / Trade-offs

- [A custom cache key must preserve request variation currently handled by Django's cache decorator] → Include the request URL and host and any response-relevant language variation in the key, and cover cache hits in tests.
- [A cache generation change before a transaction rolls back could invalidate a valid response unnecessarily] → Rotate the generation with `transaction.on_commit` so invalidation follows a successful commit.
- [The field default populates existing records during migration] → Use the same `Hi ya!` value as the model default so existing pages have a usable greeting.

## Migration Plan

1. Apply the additive migration that adds `greeting` with its default.
2. Deploy the view, template, and cache generation changes together.
3. Roll back by reverting the application change and migration; the field contains only display text and does not affect view counts.

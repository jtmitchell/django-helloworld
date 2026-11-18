# Proposal

## Why

The page greeting is currently fixed in the templates, so it cannot be tailored per page or updated through the database. Storing it on `PageViews` makes the greeting editable alongside its page record and ensures visitors see the current value after it changes.

## What Changes

- Add a `greeting` field to `PageViews`, defaulting to `Hi ya!`.
- Read the greeting for the current page in the view and pass it to the templates.
- Use the greeting as the page content and document title.
- Invalidate only the affected page's cached response when its greeting changes.

## Capabilities

### New Capabilities

- `page-greetings`: Store and display per-page greetings, refreshing the affected cached page when its greeting changes.

### Modified Capabilities

None.

## Impact

The `echo` Django app's model, view, templates, migration, and cache handling are affected. The visible document title and page heading will use the stored greeting.

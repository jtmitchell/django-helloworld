# Tasks

## 1. Store the greeting

- [ ] 1.1 Add the `greeting` `CharField` with default `Hi ya!`, generate and apply the migration, and verify new and existing `PageViews` rows have a usable greeting through a model test.

## 2. Render the greeting

- [ ] 2.1 Look up the current page's `PageViews` record by resolver page name and pass its greeting to the templates; verify the response displays the stored greeting in both the page heading and document title.

## 3. Invalidate the affected cached response

- [ ] 3.1 Add page-scoped cache generation to response caching and rotate it after a successful save only when the greeting changes; verify a cached page serves the updated greeting after save while unrelated page cache entries remain usable.
- [ ] 3.2 Verify saves that change other fields, including view-count increments, do not rotate the greeting cache generation and that a rolled-back save does not invalidate the committed response.

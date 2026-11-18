# Tasks

## 1. Page-scoped cache invalidation

- [ ] 1.1 Reuse or define the page-scoped cache generation interface from `add-page-greeting` and verify requests populate distinct page scopes without introducing duplicate cache metadata.
- [ ] 1.2 Add an invalidation helper that advances the selected page's generation; verify selected page entries become stale while other page scopes remain cached.

## 2. Django admin action

- [ ] 2.1 Add the `PageViews` admin action and completion messaging; verify it is available in the changelist and handles selected records without errors.
- [ ] 2.2 Add coverage for invalidation of selected cached pages, preservation of unselected cache entries, and records without associated cached routes; verify the relevant test suite passes.

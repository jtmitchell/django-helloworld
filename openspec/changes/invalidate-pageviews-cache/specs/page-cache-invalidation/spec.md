# Spec Delta

## Purpose

Allows administrators to refresh cached page content for selected page view records from the Django admin. Invalidation is scoped to the selected page so unrelated cached responses remain available.

## ADDED Requirements

### Requirement: Invalidate cached pages from admin
The system MUST provide an admin action that invalidates cached responses associated with selected page view records and reports the result to the administrator.

#### Scenario: Selected cached page is invalidated
- **WHEN** an administrator runs the invalidation action on one or more records for cached pages
- **THEN** subsequent requests for those pages are rendered with fresh content
- **AND** cached responses for unselected pages remain available

#### Scenario: Selected page has no current cache entry
- **WHEN** an administrator runs the invalidation action on a selected page that has no current cache entry
- **THEN** the action completes without failing
- **AND** the administrator receives a completion message that reflects the records processed

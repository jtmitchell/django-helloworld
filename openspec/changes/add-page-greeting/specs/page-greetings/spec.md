# Spec Delta

## Purpose

Page greetings let each page display a database-managed message consistently in its content and document title. Updating a page's greeting becomes visible on that page without waiting for its cached response to expire.

## ADDED Requirements

### Requirement: Pages have a default greeting
Each page record SHALL have a greeting whose default value is `Hi ya!`.

#### Scenario: A page record is created without a greeting
- **WHEN** a page record is created without specifying a greeting
- **THEN** its greeting is `Hi ya!`

### Requirement: Pages display their stored greeting
A page SHALL display the greeting associated with its page name as both its main greeting content and document title.

#### Scenario: A page with a stored greeting is rendered
- **WHEN** the page is requested
- **THEN** the stored greeting appears in the page content and document title

### Requirement: Greeting changes refresh the affected page
When a page's greeting changes, the cached response for that page SHALL be invalidated so its next request renders the new greeting.

#### Scenario: A greeting is changed for a cached page
- **GIVEN** the page has a cached response
- **WHEN** its greeting is saved with a new value
- **THEN** only that page's cached response is invalidated
- **AND** its next request displays the new greeting

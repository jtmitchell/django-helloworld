# Spec Delta

## Purpose

Defines the shared visual shell of the Django site so every page using the base template has consistent branding, legible content placement, and a recognizable background.

## ADDED Requirements

### Requirement: Shared pages use Bootstrap styling
Pages extending the shared base template SHALL render with Bootstrap layout and utility styling available.

#### Scenario: Page renders the shared template
- **WHEN** a page extending the shared base template is requested
- **THEN** Bootstrap styling is available to the rendered page

### Requirement: Shared pages show the site logo
The shared page shell SHALL show the text “hello world” inside a colored circle at the top left.

#### Scenario: User views a shared page
- **WHEN** a page extending the shared base template is rendered
- **THEN** the “hello world” logo appears in a colored circle at the top left

### Requirement: Shared pages use the Earth background
The shared page shell SHALL use the provided `ISS_earth.en.jpg` image as a static, page-wide background.

#### Scenario: User views a shared page
- **WHEN** a page extending the shared base template is rendered
- **THEN** the Earth image fills the page background

### Requirement: Shared page content is centered
The shared page shell SHALL center its page content horizontally and vertically within the available viewport.

#### Scenario: User views a shared page
- **WHEN** a page extending the shared base template is rendered
- **THEN** the page content is centered horizontally and vertically

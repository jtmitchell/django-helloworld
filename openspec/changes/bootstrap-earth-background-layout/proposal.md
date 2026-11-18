# Proposal

## Why

The Django site currently has a bare base template, so pages lack a consistent, styled shell. A simple Bootstrap layout will provide a clear starting point for the site while making its content easy to find against the requested Earth image.

## What Changes

- Add Bootstrap styling to the shared base template.
- Add a top-left circular “hello world” logo and center page content horizontally and vertically.
- Use `src/static/img/ISS_earth.en.jpg` as the page-wide background image.

## Capabilities

### New Capabilities

- `site-shell`: Shared site layout, branding, background, and content positioning.

### Modified Capabilities

None.

## Impact

- `src/templates/base.html` and static asset references.
- Bootstrap dependency delivery and Django static-file handling.

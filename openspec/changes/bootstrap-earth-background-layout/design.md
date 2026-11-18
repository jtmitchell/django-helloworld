# Design

## Context

See `proposal.md` for motivation and `specs/site-shell/spec.md` for observable behavior. The project has a shared Django base template at `src/templates/base.html`, Django staticfiles enabled, and the provided image at `src/static/img/ISS_earth.en.jpg`. There is no frontend package manifest or build pipeline.

## Goals / Non-Goals

**Goals:** Implement the shared shell using the existing template and static-file setup, with a straightforward Bootstrap layout.

**Non-Goals:** Redesign page-specific content or add a frontend build system.

## Decisions

- Load Bootstrap CSS from its official CDN in the base template. This avoids introducing a frontend build pipeline or duplicating vendor assets for a small shared layout. A locally bundled Bootstrap distribution remains an option if offline operation becomes a requirement.
- Keep the supplied Earth image at `src/static/img/ISS_earth.en.jpg` and reference it through Django's `{% static %}` tag, rather than copying or downloading another image.
- Implement the logo as text styled into a colored circle and center the content with Bootstrap layout utilities plus minimal custom CSS where viewport-height behavior needs it.
- Keep the existing instance banner and template content block in the shared shell.

## Risks / Trade-offs

- [The Bootstrap CDN requires network access in the browser] → The page remains usable with the template's own layout and color styles; bundle Bootstrap locally if offline use becomes a requirement.
- [A full-page background can reduce text contrast] → Add a restrained overlay or content surface if the existing page content needs more contrast.

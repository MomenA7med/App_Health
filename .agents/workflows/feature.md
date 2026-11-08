---
description: Implement a Flutter feature from requirements, Figma design, and API specifications while following the existing project architecture.
---

# Flutter Feature Workflow

Implement the feature requested by the user.

## Step 1 — Understand

Understand:

- Feature requirements
- Figma design
- API requirements
- User interactions
- Navigation requirements

Do not start coding before understanding the existing project.

## Step 2 — Inspect the project

Search the existing codebase for:

- Similar screens
- Existing widgets
- Existing API endpoints
- Models
- Repositories
- Cubits/Blocs/Providers
- Dependency injection
- Navigation
- Localization

Reuse existing implementations whenever possible.

Do not create duplicate functionality.

## Step 3 — Figma

If a Figma URL is provided:

- Use Figma MCP to inspect the design.
- Analyze layout.
- Analyze spacing.
- Analyze typography.
- Analyze colors.
- Identify reusable components.
- Identify assets.
- Identify loading, error and empty states.

Use Figma as the source of truth for the UI.

## Step 4 — API

If API information is provided:

- Analyze the endpoint.
- Analyze HTTP method.
- Analyze request parameters/body.
- Analyze response structure.
- Search for existing related API implementations.
- Reuse the existing Dio/API infrastructure.
- Reuse existing authentication and interceptors.
- Create typed models when necessary.

Do not invent API fields or behavior.

## Step 5 — Architecture

Follow the existing project architecture.

Reuse:

- Existing state management
- Existing repositories
- Existing services
- Existing dependency injection
- Existing navigation
- Existing design system
- Existing localization

Do not introduce a new architecture or package unless absolutely necessary.

Do not refactor unrelated code.

## Step 6 — Implementation

Implement the feature.

### Colors & Styling (AppColors)

- Never write hardcoded colors directly in the code or widgets (no `Color(0xFF...)` in UI files).
- All colors must exist and be defined in `AppColors` (`lib/res/app_colors.dart`).
- When adding a new color:
  1. Name the color using: https://chir.ag/projects/name-that-color/
  2. Define it as a private constant in `AppColors`:
     ```dart
     static const Color _hippieBlue = Color(0xff50A0A4);
     ```
  3. Define the public / semantic constant:
     ```dart
     static const colorPrimary = _hippieBlue;
     ```
  4. Use `AppColors.<colorConstant>` in the screens and widgets.

Make sure to handle:

- Loading state
- Success state
- Error state
- Empty state when applicable
- API errors
- User interactions
- Navigation
- Localization

Keep the implementation focused on the requested feature.

## Step 7 — Definition of Done

The feature is NOT complete until all applicable checks pass.

### UI

- [ ] UI matches the Figma design.
- [ ] No hardcoded colors in UI code. All colors are defined in `AppColors`.
- [ ] New colors in `AppColors` named via https://chir.ag/projects/name-that-color/ (`_colorName` -> public constant) and used in screens.
- [ ] Existing design system components are reused.
- [ ] Loading state handled.
- [ ] Error state handled.
- [ ] Empty state handled when applicable.
- [ ] User interactions implemented.

### API

- [ ] Correct endpoint implemented.
- [ ] Correct HTTP method used.
- [ ] Correct request implemented.
- [ ] Correct response model implemented.
- [ ] Existing Dio/API infrastructure reused.
- [ ] Existing authentication/interceptors reused.
- [ ] API errors handled.

### Architecture

- [ ] Existing architecture followed.
- [ ] Existing state management used.
- [ ] Existing dependency injection used.
- [ ] Existing navigation used.
- [ ] No unnecessary abstractions introduced.
- [ ] No unrelated refactoring performed.

### Localization

- [ ] User-facing strings use the existing localization system.
- [ ] No unnecessary hardcoded strings.

### Testing

- [ ] Relevant tests added or updated.
- [ ] Success case covered.
- [ ] Error case covered where applicable.
- [ ] Important business logic tested.

### Validation

- [ ] flutter analyze passes.
- [ ] Relevant tests pass.
- [ ] Final git diff reviewed.
- [ ] No unrelated files modified.

## Step 8 — Final report

At the end, report:

1. What was implemented.
2. Files created.
3. Files modified.
4. API changes.
5. Tests added.
6. flutter analyze result.
7. Test result.
8. Any remaining issues.
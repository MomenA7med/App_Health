---
trigger: always_on
---

# Flutter Project Guardrails

## Architecture

- Always follow the existing Flutter project architecture.
- Before creating a new class, search for existing similar implementations.
- Reuse existing repositories, services, API managers, widgets and utilities.
- Do not introduce a new architecture or design pattern unless explicitly requested.
- Do not refactor unrelated code.

## Flutter

- Follow the existing state management solution.
- Follow the existing dependency injection pattern.
- Follow the existing navigation and routing pattern.
- Prefer const widgets where possible.
- Avoid unnecessary widget rebuilds.
- Keep widgets focused and maintainable.

## API

- Use the existing Dio/API infrastructure.
- Never create a new Dio instance if one already exists.
- Never hardcode API base URLs.
- Reuse existing interceptors and authentication handling.
- Follow existing API error handling.
- Do not invent API fields.
- Use typed request and response models.

## UI

- When Figma is provided, use it as the source of truth.
- Reuse existing design system components.
- Reuse existing colors, typography and spacing.
- Do not invent UI components when an existing component can be reused.
- Handle loading, error and empty states.

## Localization

- All user-facing strings must use the existing localization system.
- Do not hardcode user-facing strings.

## Dependencies

- Do not add a new package unless absolutely necessary.
- Check the existing project before introducing a dependency.

## Scope

- Do not modify unrelated files.
- Do not delete existing functionality unless explicitly requested.
- Keep changes focused on the requested feature.

## Validation

- Run flutter analyze after implementation.
- Run relevant tests.
- Review the final git diff.
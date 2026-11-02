---
name: flutter-feature
description: Implements Flutter features that involve Figma designs, APIs, state management, repositories, navigation, localization and tests. Use when implementing a new Flutter feature.
---

# Flutter Feature Skill

## Goal

Implement Flutter features while following the existing project architecture.

## Before coding

1. Inspect the project structure.
2. Identify the existing architecture.
3. Search for similar features.
4. Search for existing API implementations.
5. Search for reusable widgets.
6. Identify the state management pattern.
7. Identify dependency injection patterns.
8. Identify navigation patterns.
9. Identify localization patterns.

## Figma

When a Figma URL is provided:

1. Inspect the relevant frame using Figma MCP.
2. Analyze layout.
3. Analyze spacing.
4. Analyze typography.
5. Analyze colors.
6. Identify reusable components.
7. Identify assets.
8. Identify loading, error and empty states.

Do not approximate the design when the required information is available from Figma.

## API

When API information is provided:

1. Inspect the existing API architecture.
2. Search for the endpoint.
3. Search for related models.
4. Search for related repositories.
5. Reuse existing API infrastructure.
6. Create models only when necessary.
7. Do not invent response fields.

## Implementation

Implement in this order:

1. Models
2. API/repository layer
3. State management
4. Dependency injection
5. UI
6. Navigation
7. Localization
8. Tests

Follow the existing project conventions.

## Quality

Before considering the feature complete:

- Run flutter analyze.
- Run relevant tests.
- Check loading state.
- Check error state.
- Check empty state.
- Check API error handling.
- Review the Figma implementation.
- Review git diff.
---
applyTo: "Frontend/**/*.tsx,Frontend/**/*.ts"
---

# Frontend Instructions

## Technology

- React
- TypeScript
- Functional components

## Components

- Prefer small reusable components.
- Keep business logic outside presentation components when practical.
- Do not use class components.

## API

HTTP communication should be implemented through the existing API/service layer.

Components should not contain raw HTTP requests unless an existing project pattern requires it.

## TypeScript

- Avoid `any`.
- Prefer explicit types for public interfaces.
- Reuse existing types where possible.
- Keep API models consistent with backend DTOs.

## State

Follow the existing state-management approach in the project.
Do not introduce a new state-management library without explicit approval.
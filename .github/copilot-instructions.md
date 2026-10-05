# Copilot Instructions

When working on this repository:

- Follow the existing architecture and coding patterns.
- Prefer small, focused changes.
- Before creating new abstractions, search the repository for existing implementations.
- Reuse existing services, DTOs and utilities whenever possible.
- Do not introduce dependencies unless necessary.
- When requirements are ambiguous, inspect the existing code before making assumptions.

For changes that affect multiple layers:

1. Database
2. Backend
3. API contract
4. Frontend
5. Tests

Consider all affected layers before implementing the change.

When modifying an API contract, check both backend and frontend consumers.
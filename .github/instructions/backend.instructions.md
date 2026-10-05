---
applyTo: "Backend/**/*.cs"
---

# Backend Instructions

## Technology

- .NET 10
- ASP.NET Core Web API
- C#
- Entity Framework Core

## Architecture

The backend follows Clean Architecture.

Dependency direction:

Domain
    ↑
Application
    ↑
Infrastructure
    ↑
Api

### Domain

- Contains business entities and business rules.
- Must not depend on Infrastructure or Api.

### Application

- Contains application services and interfaces.
- Defines abstractions required by Infrastructure.

### Infrastructure

- Contains database access and external integrations.
- Implements interfaces defined by Application.

### Api

- Contains controllers and HTTP-related concerns.
- Controllers should remain thin.


## Controllers

Controllers should:

- Validate HTTP-specific input.
- Call application services.
- Return appropriate HTTP responses.

Controllers should NOT contain business logic or direct database access.

## C#

- Use async/await for I/O operations.
- Prefer dependency injection.
- Use nullable reference types.
- Follow existing naming conventions.
- Avoid unnecessary abstractions.
- Call database only through stored procidures.
- Write all method declaration parameters in one line.
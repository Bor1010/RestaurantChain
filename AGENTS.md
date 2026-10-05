# MyProject — AI Agent Instructions

## Project Overview

MyProject is a web application consisting of:

- ASP.NET Core Web API backend
- React + TypeScript frontend
- Microsoft SQL Server database

## Repository Structure

- `Backend/` — .NET backend
- `Frontend/` — React frontend
- `Database/` — database scripts
- `Tests/` — automated tests

## General Rules

- Prefer existing project patterns over introducing new ones.
- Do not introduce new NuGet or npm packages without a good reason.
- Do not modify unrelated files.
- Keep changes focused on the requested task.
- Do not change the overall architecture without discussing it first.
- Never commit secrets, passwords, API keys or connection strings.

## Development Workflow

Before implementing a significant change:

1. Inspect the existing implementation.
2. Identify the relevant layers and files.
3. Explain the proposed approach if architectural changes are required.


After implementation:

1. Build the affected projects.
2. Run relevant tests.
3. Fix compilation errors.
4. Fix failing tests.
5. Review the final changes for unnecessary modifications.


## Git

Do not create commits unless explicitly requested.

Do not modify `.gitignore` or CI configuration unless required by the task.
# CLAUDE.md

## Project Purpose

Build and maintain **PantryPilot**, a native iPhone meal planning application for personal use.

## Session Workflow

At the start of every session:

1. Read `PROJECT_SPEC.md`.
2. Read `TODO.md` (if present).
3. Read `HANDOFF.md` (if present).
4. Understand the current state before making changes.

## Development Rules

- Work on **one feature only** at a time.
- Never leave partially implemented functionality.
- Prefer production-ready implementations over placeholders.
- Keep files modular and well organised.
- Use SwiftUI, SwiftData, Observation, async/await and modern Apple APIs.
- Avoid unnecessary dependencies.
- Prefer native frameworks whenever practical.
- Maintain accessibility, performance and testability.

## Quality Standards

Before considering a feature complete:

- Build succeeds.
- No compiler warnings introduced.
- Refactor duplicated code.
- Add/update documentation where appropriate.
- Verify UI on common iPhone sizes.
- Ensure Dark Mode compatibility.

## End of Feature Checklist

- Update `TODO.md`.
- Update `HANDOFF.md`.
- Commit changes with a meaningful Git message.

## General Principles

- Keep architecture clean.
- Keep context usage efficient.
- Never rewrite unrelated code.
- Preserve backwards compatibility unless intentionally refactoring.

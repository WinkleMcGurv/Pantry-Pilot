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

## Scope Control

Never continue into another phase once the requested phase is complete.

Do not implement adjacent features "while you're there".

Do not perform speculative refactors.

Do not optimise unrelated code.

Avoid creating new files unless there is a clear architectural benefit.

Prefer extending existing components over creating new abstractions.

# Graphify Workflow

## Purpose

Graphify exists to help understand project structure and dependencies when required.

It is **not** part of the normal development workflow and should be used sparingly to minimise context usage and execution time.

## General Rules

- Do not automatically run `graphify update .`
- Do not automatically read `graphify-out/GRAPH_REPORT.md`
- Do not regenerate the graph after every feature
- Do not use Graphify when the required information can be determined directly from the relevant source files

## When to Use Graphify

Only use Graphify if one of the following is true:

- locating where existing functionality lives
- understanding complex dependencies
- tracing data flow between components
- planning a significant architectural refactor
- explicitly requested by the user

## When NOT to Use Graphify

Do not use Graphify for:

- normal feature development
- UI work
- small bug fixes
- documentation updates
- refactoring isolated files
- code already well understood from local inspection

## Updating the Graph

Only run:

graphify update .

when:

- major architectural changes have been completed
- multiple new modules/features have been introduced
- the user explicitly requests an updated graph

Never update the graph after every coding session.

## Context Efficiency

Prefer:

- reading only the files relevant to the current task
- targeted code searches
- existing project documentation

over Graphify whenever practical.

## Graph Reports

Treat `graphify-out/GRAPH_REPORT.md` as a high-level architectural reference only.

Do not repeatedly reread it during a session unless architecture has changed or the current task specifically requires it.


# Context Optimisation

Always minimise token usage.

- Read PROJECT_SPEC.md once at the start of a session.
- Afterwards, consult only the sections relevant to the current task.
- Read only the source files needed for the current feature.
- Avoid broad project scans.
- Avoid reanalysing completed features unless they are directly affected.
- Extend existing components before creating new abstractions.
- Stop immediately after the requested feature is complete.

# HANDOFF.md

_Last updated: 2026-07-17 — end of **Phase 1: Architecture Foundation**._

## Summary

The PantryPilot Xcode project is created and builds cleanly (0 warnings) for
iOS 18+, and launches on the simulator. This session delivered the full
architectural foundation — design system, navigation, data model, services and
dependency injection — with a branded placeholder screen for every major
section so navigation is fully testable. **No business logic, AI, or meal-
planning behaviour was implemented**, by design.

- **61 Swift files**, organised by layer/feature.
- Verified: `xcodebuild` **BUILD SUCCEEDED**, app installs, launches and renders
  the onboarding screen with the design system applied (no crash).
- Git: committed on `main`. Phase 1 foundation is the first commit; the docs
  commit follows. Working tree clean at session close.
- `CLAUDE.md` gained a **Scope Control** section this session (work stays within
  the requested phase) — Phase 1 was delivered within that boundary.

## How to build

```bash
# Regenerate the Xcode project after adding/removing files:
xcodegen generate

# Build for the simulator:
xcodebuild build -project PantryPilot.xcodeproj -scheme PantryPilot \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

> The `.xcodeproj` is generated from `project.yml` and is **git-ignored** — edit
> `project.yml`, not the project file. Adding a `.swift` file under `PantryPilot/`
> and re-running `xcodegen generate` is all that's needed to include it.

## Project structure

```
PantryPilot/
  App/           App entry, DI container, root/onboarding gate
  Core/
    DesignSystem/  Foundations (colour/type/spacing/layout/icons),
                   Theme, Components
    Navigation/    AppTab, AppRoute, AppRouter, MainTabView, RootToolbar
    Persistence/   AppSchema, PersistenceController, DataStore, PreviewData
    Services/      Protocols + Implementations
    Utilities/     AppError, AppConstants, AppLogger, Formatters
    Extensions/    Date/View helpers
  Models/        SwiftData @Model types + enums + Nutrition value type
  Features/      One folder per section (placeholder screens for now)
  Resources/     Assets.xcassets (AppIcon, AccentColor), Info.plist
```

## Key architectural decisions

1. **XcodeGen over a checked-in `.xcodeproj`.** Reproducible, reviewable in
   `project.yml`, no merge conflicts in `pbxproj`. Trade-off: contributors need
   `xcodegen` (`brew install xcodegen`) and must regenerate after file changes.

2. **Single app target, feature-folder modularity.** Keeps the build simple and
   dependency-free (per `CLAUDE.md`) while staying clearly organised. Can be
   split into SPM modules later if compile times demand it.

3. **Swift 5 language mode** (`SWIFT_VERSION = 5.0`, `SWIFT_STRICT_CONCURRENCY =
   minimal`). Deliberate: avoids Swift 6 strict-concurrency churn on foundation
   code while still using SwiftData/Observation/async-await. **Revisit** once
   feature code stabilises — moving to Swift 6 later is a contained migration.

4. **Colours defined in code** as light/dark pairs (`AppColor`) rather than in
   the asset catalog — fully version-controlled, testable, guaranteed dark-mode
   adaptation. `AccentColor` is duplicated in the catalog only for the system
   tint. All type uses rounded system fonts scaled for Dynamic Type.

5. **SwiftData schema centralised** in `AppSchema` with a version, ready for a
   `SchemaMigrationPlan` when models change. Multi-select enum fields on
   `UserProfile`/`Recipe` are stored as `[String]` raw values with typed
   computed accessors — keeps the store stable across enum changes.

6. **Generic `DataStore`** abstraction over `ModelContext` so feature layers
   depend on a protocol, not SwiftData directly (testable, swappable).

7. **DI via `@Observable AppContainer`** injected with `.environment`. Provides
   `.live()` (production services) and `.preview()` (in-memory + sample data).
   Services are protocol-first: infra ones are **complete** (`LiveHapticService`,
   `LocalNotificationService`, persistence); AI/planner ones are **honest
   stubs** (`UnavailableMealPlanningService`, `UnavailableAIAssistantService`)
   that throw `AppError.notImplemented` — no partial/half-wired behaviour.

8. **Navigation:** `AppRouter` (`@Observable`) owns selected tab, a per-tab
   `[AppRoute]` path, and a global `AppSheet`. Each tab is its own
   `NavigationStack`; routes resolve via `AppRoute.destination()`. Value-based
   `NavigationLink`s in the placeholder screens already exercise pushes.

## Data model (SwiftData)

`UserProfile`, `PantryItem`, `Recipe` ↔ `RecipeIngredient` (cascade),
`MealPlan` ↔ `PlannedMeal` (cascade), `ShoppingList` ↔ `ShoppingListItem`
(cascade), `MealLogEntry`. `Nutrition` is an embedded `Codable` value type.
Shared enums live in `Models/Enums/ModelEnums.swift`.

## Known intentional gaps (by design this session)

- All feature screens are branded placeholders (`PlaceholderScreen`) tagged with
  their target phase.
- Onboarding is a single welcome screen that creates a minimal `UserProfile`
  and flips `onboardingCompleted` so the main app is reachable; the full
  questionnaire is Phase 4.
- No recipe seed data yet (beyond `PreviewData` used only in previews).
- App icon is a placeholder (no artwork).

## ▶️ Recommended next task

**Phase 4 — Onboarding (full questionnaire).** It is the natural next step: it
populates `UserProfile` (already modelled), reuses the design-system components
(`PPTextField`, `PPChip`, `PPButton`, `SectionHeader`), and unblocks the planner
and budget logic that depend on the user's goals, budget and preferences.
Alternatively, **Phase 5 — Pantry** is a good self-contained CRUD warm-up if you
prefer to validate the `DataStore`/repository pattern end-to-end first.

See `TODO.md` for the full phased backlog.

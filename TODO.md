# TODO.md

Development backlog for **PantryPilot**, broken into logical phases. Work one
feature at a time (per `CLAUDE.md`). Each phase should be completed, tested,
documented and committed before the next begins.

Legend: `[ ]` pending · `[~]` in progress · `[x]` done

---

## Phase 1 — Project Architecture & Foundations ✅ (this session)

- [x] Xcode project generated via XcodeGen (`project.yml`)
- [x] Folder structure (App / Core / Models / Features / Resources)
- [x] Design system (colours, typography, spacing, layout, icons, components, theming)
- [x] Navigation architecture (tabs, routes, router, per-tab stacks, sheets)
- [x] SwiftData schema + `ModelContainer` + generic `DataStore`
- [x] Service protocols + infra implementations + honest AI/planner stubs
- [x] Dependency injection (`AppContainer` live/preview)
- [x] Placeholder screens for every major section
- [x] Onboarding gate
- [x] Builds cleanly (0 warnings) and launches on simulator

---

## Phase 2 — Design System Polish

- [ ] Add unit tests for formatters, date helpers, model computed properties
- [ ] Snapshot/preview catalogue screen for every component
- [ ] Accessibility audit: Dynamic Type at XL sizes, VoiceOver labels, contrast
- [ ] Reduce-motion & increase-contrast handling
- [ ] Haptic feedback pass on interactive components

## Phase 3 — Navigation Hardening

- [ ] Deep-link / restoration support for `AppRoute`
- [ ] Programmatic navigation coverage (push/pop/reset) via `AppRouter`
- [ ] Tab re-selection → pop-to-root behaviour

## Phase 4 — Onboarding (full)

- [ ] Multi-step questionnaire capturing every `PROJECT_SPEC` field
- [ ] Body metrics → suggested calorie/protein targets
- [ ] Cuisine / food / allergy / diet multi-selects (reuse `PPChip`)
- [ ] Preferred supermarkets & household size
- [ ] Persist to `UserProfile`; editable later from Profile screen
- [ ] Validation + progress indicator

## Phase 5 — Pantry

- [ ] Pantry list grouped by storage location
- [ ] Add / edit / delete `PantryItem`
- [ ] Expiry sorting + "expiring soon" badges
- [ ] Quantity & unit editing, photo attach
- [ ] Barcode field (manual entry now; scanning is a premium enhancement)

## Phase 6 — Recipe Database & Explorer

- [ ] Seed/import a starter recipe set
- [ ] `RecipeRepository` (backed by `DataStore`)
- [ ] Recipe detail screen (image, method, nutrition, cost, equipment)
- [ ] Explorer search + filters (calories, protein, budget, cuisine, meal type,
      time, difficulty, ingredients, diet, allergens)
- [ ] Favourite recipes

## Phase 7 — Meal Planner & Calendar

- [ ] Weekly planner grid (breakfast/lunch/dinner/snacks)
- [ ] Lock / swap / duplicate / regenerate meal slots
- [ ] Save favourite weeks
- [ ] Monthly calendar view
- [ ] Meal-prep mode (batch by shared ingredients)
- [ ] Rule-based planning engine behind `MealPlanningService` (pre-AI)

## Phase 8 — Shopping Lists & Budget

- [ ] Generate list from a `MealPlan` (`ShoppingListService`)
- [ ] Merge duplicates, subtract pantry stock, group by aisle
- [ ] Tick / share / copy / print
- [ ] Budget engine: estimated spend, remaining budget, cost/meal, savings

## Phase 9 — Statistics

- [ ] Log cooked meals (`MealLogEntry`)
- [ ] Calories & macro trends, grocery spend, waste reduction, meals cooked
- [ ] Charts (load the `dataviz` guidance before building charts)

## Phase 10 — Notifications

- [ ] Meal, shopping, expiry and meal-prep reminders via `NotificationService`
- [ ] Notification preferences screen
- [ ] Permission priming flow

## Phase 11 — AI Integration

- [ ] Real `MealPlanningService` (weekly plan generation)
- [ ] `AIAssistantService`: pantry suggestions, substitutions, nutrition advice,
      cooking assistant
- [ ] Model/provider selection & prompt design (see the `claude-api` guidance)
- [ ] Graceful offline / error handling

## Phase 12 — Premium Enhancements

- [ ] Barcode scanning · Receipt scanning · Voice input
- [ ] Widgets · Live Activities · Siri Shortcuts
- [ ] Apple Health integration · Apple Watch app
- [ ] iCloud sync (SwiftData + CloudKit) · Offline support

## Phase 13 — Polish, Testing & Release

- [ ] Empty/loading/error states across all features
- [ ] Performance pass (startup, scrolling, battery)
- [ ] Full accessibility & localisation pass
- [ ] Unit + UI test coverage
- [ ] App icon artwork, App Store assets, privacy manifest

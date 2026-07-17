# HANDOFF.md

_Last updated: 2026-07-17 — end of **Phase 4: Onboarding (full questionnaire)**._

## Summary

This session replaced the single-screen onboarding gate with the full
multi-step questionnaire from `PROJECT_SPEC.md`. Every spec field is captured
(name, age, height, weight, activity, goal, calories, protein, budget, meals
per day, cooking ability, cooking time, cuisines, favourite/disliked foods,
allergies, dietary preferences, household size, supermarkets), persisted to
`UserProfile`, and the completed profile gates into the main app.

Verified end-to-end on the iPhone 17 simulator with a temporary XCUITest
harness (removed before commit): validation gating, the suggested-targets
estimator (asserted 3375 kcal / 134 g for a known input), "No preference"
exclusivity, tag editors, the SwiftData row (checked via sqlite3), the
relaunch gate, and Dark Mode via the app's theme preference. Build succeeds
with 0 compiler warnings. See `.claude/skills/verify/SKILL.md` (new) for the
reusable verification recipe, including simulator gotchas.

## What was added

- `Features/Onboarding/OnboardingViewModel.swift` — `@Observable` draft state,
  per-step validation (`validationMessage(for:)`), navigation, tag handling,
  nutrition estimation and `complete(in:)` persistence. Estimation uses
  Mifflin–St Jeor with a **sex-neutral midpoint** constant (spec collects no
  sex field), activity multipliers (1.2–1.9) and goal adjustments
  (−400 / +300 kcal; 1.4–2.0 g/kg protein), labelled as an estimate in the UI.
- `Features/Onboarding/OnboardingSteps.swift` — welcome, about, body/activity,
  goals, cooking, tastes, restrictions, budget/shopping and summary steps.
- `Features/Onboarding/OnboardingControls.swift` — step scaffold, option
  cards, stepper row (accessibility-adjustable), chip grid, tag editor.
  Deliberately private to onboarding; promote to the design system only when
  a second feature needs them.
- `Core/DesignSystem/Components/FlowLayout.swift` — reusable wrapping layout
  for chips/tags (Recipe Explorer filters will want it too).
- `OnboardingView.swift` (rewritten) — animated progress bar, back button,
  directional slide transitions (plain fade under Reduce Motion), footer with
  validation hint + gated Continue, save-failure alert, haptics throughout.
- `PPChip` now exposes the `.isSelected` accessibility trait; `AppIcon` gained
  `chevronLeft`.

## Behaviour notes

- Only the name is required; optional numerics validate range **only when
  filled** ("or left blank" messaging). Limits live in
  `OnboardingViewModel.Limits`.
- "No preference" (diet) is mutually exclusive with the other diet chips —
  handled in `toggle(_: DietaryPreference)` and stored as an empty array.
- Supermarkets: ten common UK chains as one-tap chips + free-text entry for
  others; all merge into `preferredSupermarkets`.
- The estimator card only appears once age/height/weight are all valid;
  "Use these targets" copies values into the editable fields.
- `RootView`'s `@Query`-based gate is unchanged; `onFinished` remains a no-op
  closure by design.

## Watch out for

- The simulator runtime here **ignores `simctl ui booted appearance dark`**
  (even system Settings stays light). Test dark mode via
  `defaults write com.pantrypilot.app settings.appearanceMode dark` + relaunch.
- `UserProfile.dietaryPreferences` accessor filters unknown raw values; the
  `.none` case is intentionally never persisted.
- Onboarding controls assume portrait iPhone (per project settings).

## ▶️ Recommended next task

**Phase 5 — Pantry** (list grouped by storage location, CRUD for `PantryItem`,
expiry badges). It validates the `DataStore` repository pattern end-to-end and
is self-contained. Phases 2–3 (design-system polish, navigation hardening)
remain open and can be slotted in whenever.

See `TODO.md` for the full phased backlog.

# HANDOFF.md

_Last updated: 2026-07-17 — session close after **Phase 4 (Onboarding)** and
**Phase 5 (Pantry)**. Working tree clean; Graphify graph regenerated (737
nodes / 1237 edges) to reflect the two new feature modules and route wiring.
App deployed to Gavin's iPhone and confirmed working (status: **Working**)._

## Summary

This session delivered the pantry inventory: a list grouped by storage
location (canonical `StorageLocation` order, soonest expiry first within each
section), full add/edit/delete for `PantryItem`, expiry badges, photo attach
and a manual barcode field. Earlier the same day, Phase 4 onboarding shipped
with two rounds of on-device feedback fixes (keyboard focus chaining +
Next/Done accessory; bottom CTA hides while typing; meals-per-day floor of 1),
and the app was deployed to Gavin's iPhone (paired device "Gavin",
`devicectl`; bundle ID **com.gurv.PantryPilot** — the original
com.pantrypilot.app was taken by another team; team ID is set in
`project.yml`).

Verified end-to-end on the iPhone 17 simulator via a temporary XCUITest
harness (removed before commit): empty state → add (name, 200 g, Fridge,
Dairy & Eggs, expiry +3 days) → grouped row with "3 days" badge → edit to
150 g → relaunch persistence → swipe-delete → empty state. Build has 0
compiler warnings. See `.claude/skills/verify/SKILL.md` for the recipe.

## What was added (Phase 5)

- `Features/Pantry/PantryItemForm.swift` — `PantryItemDraft` (value-type
  working copy; parsing/validation; `apply(to:)`/`makeItem()`) and
  `PantryItemFormFields` (name, quantity + unit chips, storage chips,
  category chips, expiry toggle + date picker, PhotosPicker with downscaling
  to ≤1200px JPEG, barcode field). Reuses `OnboardingChipGrid` and
  `keyboardDoneToolbar` from onboarding.
- `Features/Pantry/PantryItemEditorViews.swift` — `PantryItemEditorContent`
  (scroll + bottom CTA that hides while the keyboard is up, per the app's
  form convention), `AddPantryItemSheet` (modal create) and
  `PantryItemDetailView` (pushed editor with delete confirmation; resolves
  its item by `id` via `@Query`, shows a graceful "Item removed" state if
  it vanishes).
- `PantryView.swift` (rewritten) — grouped `List` (`.insetGrouped`, themed),
  rows with photo/icon thumbnail, quantity + unit, expiry subtitle, urgent
  badges (`Expired`/`Today`/`1 day`/`N days` ≤ 3), swipe-to-delete,
  empty state, add button in the leading toolbar slot.
- `PantryItem` gained `@Attribute(.unique) id: UUID` (matches `Recipe`;
  required by the `pantryItemDetail(itemID:)` route — additive, lightweight
  migration). `daysUntilExpiry` is now **calendar-day based**
  (startOfDay-to-startOfDay; 0 = today, negative = expired).
- `AppRoute.pantryItemDetail` now resolves to the real detail view.

## Conventions to carry forward

- **Forms:** bottom CTA hides while the keyboard is visible; number/decimal
  pads get the `keyboardDoneToolbar` accessory with Next-chaining between
  fields. (Direct user feedback — do not regress this.)
- **Mutations** go through `container.dataStore` (+ haptics on success/error);
  reactive reads use `@Query`.
- Do **not** put `.accessibilityLabel` on a chip grid container — it collapses
  the grid into one element and hides the chip buttons (caught by UI test).

## User context (from device testing)

- Household of 2; not every day has every meal — sometimes one shared evening
  meal. Planner (Phase 7) must handle sparse days and includes a backlog item
  for a "random meal from pantry + top-up shop" suggester (user request).
- Phase 9 gained ad-hoc food logging (full calorie tracker, not plan-only).
- Free Apple ID provisioning: device installs expire after 7 days; redeploy
  with the CLI recipe in `.claude/skills/verify/SKILL.md` (build with
  `-allowProvisioningUpdates`, install/launch via `devicectl`, device ID
  `AFC67B0F-5511-511F-86C3-2300F10ACBD6`).

## ▶️ Recommended next task

**Phase 6 — Recipe Database & Explorer** (seed recipes, `RecipeRepository`,
detail screen, search + filters, favourites). It unblocks the planner and the
random-meal suggester. Phases 2–3 (polish/hardening) remain open for whenever
a lighter session is wanted.

See `TODO.md` for the full phased backlog.

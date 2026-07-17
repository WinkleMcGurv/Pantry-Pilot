# PROJECT_SPEC.md

# PantryPilot

## Vision

PantryPilot is a premium native iPhone application designed to eliminate the effort of weekly meal planning while reducing grocery costs and food waste.

This application should be an original implementation inspired by modern AI meal planners, not a clone of any existing product.

---

# Primary Goals

- Generate intelligent weekly meal plans.
- Reduce food waste.
- Optimise grocery spending.
- Reuse pantry ingredients.
- Meet nutritional goals.
- Minimise planning effort.

---

# Target Platform

- iOS 18+
- Swift
- SwiftUI
- SwiftData
- Observation Framework
- MVVM
- async/await

---

# Design Philosophy

- Apple-quality interface.
- Original branding and layouts.
- Native navigation.
- Fluid animations.
- Excellent accessibility.
- Light and Dark Mode.

---

# Core Features

## Onboarding

Collect:

- Name
- Age
- Height
- Weight
- Activity level
- Goal
- Daily calories
- Protein target
- Budget
- Meals per day
- Cooking ability
- Cooking time
- Favourite cuisines
- Favourite foods
- Disliked foods
- Allergies
- Dietary preferences
- Household size
- Preferred supermarkets

---

## Pantry

Maintain ingredient inventory.

Each ingredient supports:

- Name
- Quantity
- Unit
- Expiry date
- Storage location
- Optional barcode
- Optional photo

Planner should prioritise using pantry stock.

---

## AI Meal Planner

Generate:

- Breakfast
- Lunch
- Dinner
- Snacks

Support:

- Regenerate week
- Regenerate meal
- Lock meals
- Swap meals
- Duplicate meals
- Save favourite weeks

---

## Recipes

Each recipe includes:

- Image
- Description
- Ingredients
- Method
- Timings
- Nutrition
- Calories
- Protein
- Fat
- Carbs
- Servings
- Estimated cost
- Difficulty
- Equipment

---

## Recipe Explorer

Search and filter by:

- Calories
- Protein
- Budget
- Cuisine
- Meal type
- Time
- Difficulty
- Ingredients
- Diet
- Allergens

---

## Shopping Lists

Automatically generate shopping lists.

Features:

- Merge duplicates
- Group by aisle
- Tick items
- Share
- Copy
- Print

---

## Budget Engine

Display:

- Estimated spend
- Remaining budget
- Cost per meal
- Savings

---

## Calendar

Weekly planner.

Monthly planner.

Meal prep mode.

---

## Statistics

Track:

- Calories
- Macros
- Grocery spend
- Food waste reduction
- Meals cooked

---

## Notifications

- Meal reminders
- Shopping reminders
- Pantry expiry reminders
- Meal prep reminders

---

## AI Features

- Weekly plan generation
- Pantry recipe suggestions
- Ingredient substitutions
- Nutrition advice
- Cooking assistant

---

# Premium Enhancements

- Barcode scanning
- Receipt scanning
- Voice input
- Apple Health integration
- Siri shortcuts
- Widgets
- Live Activities
- Apple Watch support
- iCloud Sync
- Offline support

---

# Non-Functional Requirements

- Fast startup
- Smooth scrolling
- Efficient battery use
- Modular architecture
- Fully documented code
- Production-ready quality
- Accessibility support

---

# Development Strategy

Implement incrementally.

Suggested order:

1. Project architecture
2. Design system
3. Navigation
4. Onboarding
5. Pantry
6. Recipe database
7. Meal planner
8. Shopping lists
9. Statistics
10. Notifications
11. AI integration
12. Widgets
13. Health integration
14. Polish
15. Testing
16. Release preparation

Each feature should be completed, tested, documented and committed before the next begins.

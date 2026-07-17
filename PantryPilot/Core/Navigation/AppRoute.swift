//
//  AppRoute.swift
//  PantryPilot
//
//  Typed, value-based navigation destinations pushed onto a `NavigationStack`.
//  Placeholder screens are wired here so navigation is fully exercisable before
//  feature logic exists.
//

import SwiftUI

/// A push destination within a tab's navigation stack.
enum AppRoute: Hashable {
    case recipeDetail(recipeID: UUID)
    case recipeExplorer
    case pantryItemDetail(itemID: UUID)
    case shoppingListDetail(listID: UUID)
    case budget
    case calendar
    case statisticsDetail
    case mealPrep
}

/// A destination presented modally over the whole app.
enum AppSheet: Hashable, Identifiable {
    case settings
    case profile
    case assistant
    case notifications

    var id: Self { self }
}

extension AppRoute {
    /// The view a route resolves to. During the architecture phase these are
    /// branded placeholders; feature phases replace each case with the real UI.
    @ViewBuilder
    @MainActor
    func destination() -> some View {
        switch self {
        case .recipeDetail:
            PlaceholderScreen(icon: .recipes, title: "Recipe Detail",
                              message: "Full recipe view with method, nutrition and cost.",
                              phase: "Phase 6")
                .navigationTitle("Recipe")
                .navigationBarTitleDisplayMode(.inline)
        case .recipeExplorer:
            PlaceholderScreen(icon: .search, title: "Recipe Explorer",
                              message: "Search and filter recipes by calories, budget, cuisine and more.",
                              phase: "Phase 6")
                .navigationTitle("Explore")
        case .pantryItemDetail:
            PlaceholderScreen(icon: .pantry, title: "Pantry Item",
                              message: "Edit quantity, expiry, storage and photo.",
                              phase: "Phase 5")
                .navigationTitle("Item")
                .navigationBarTitleDisplayMode(.inline)
        case .shoppingListDetail:
            PlaceholderScreen(icon: .shopping, title: "Shopping List",
                              message: "Aisle-grouped list with tick-off, share and print.",
                              phase: "Phase 8")
                .navigationTitle("List")
        case .budget:
            PlaceholderScreen(icon: .budget, title: "Budget",
                              message: "Estimated spend, remaining budget, cost per meal and savings.",
                              phase: "Phase 8")
                .navigationTitle("Budget")
        case .calendar:
            PlaceholderScreen(icon: .calendar, title: "Calendar",
                              message: "Weekly and monthly planning plus meal-prep mode.",
                              phase: "Phase 7")
                .navigationTitle("Calendar")
        case .statisticsDetail:
            PlaceholderScreen(icon: .stats, title: "Statistics Detail",
                              message: "Deep dives into calories, macros, spend and waste.",
                              phase: "Phase 9")
                .navigationTitle("Details")
        case .mealPrep:
            PlaceholderScreen(icon: .calendar, title: "Meal Prep Mode",
                              message: "Batch-cook guidance grouped by shared ingredients.",
                              phase: "Phase 7")
                .navigationTitle("Meal Prep")
        }
    }
}

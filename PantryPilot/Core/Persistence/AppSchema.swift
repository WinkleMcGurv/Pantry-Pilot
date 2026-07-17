//
//  AppSchema.swift
//  PantryPilot
//
//  Single source of truth for the SwiftData schema. Registering every model in
//  one place keeps the `ModelContainer` and any future migration plan in sync.
//

import SwiftData

enum AppSchema {
    /// Every persistent model in the app, in a stable order.
    static let models: [any PersistentModel.Type] = [
        UserProfile.self,
        PantryItem.self,
        Recipe.self,
        RecipeIngredient.self,
        MealPlan.self,
        PlannedMeal.self,
        ShoppingList.self,
        ShoppingListItem.self,
        MealLogEntry.self
    ]

    /// The current schema version. Bump alongside a `SchemaMigrationPlan` when
    /// the model layout changes in a breaking way.
    static let version = Schema.Version(1, 0, 0)

    static var schema: Schema {
        Schema(models, version: version)
    }
}

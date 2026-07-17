//
//  PlannedMeal.swift
//  PantryPilot
//
//  A single meal slot within a ``MealPlan`` (a recipe on a given day + type).
//

import Foundation
import SwiftData

@Model
final class PlannedMeal {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mealTypeRaw: String
    /// Number of servings to prepare for this slot.
    var servings: Int
    /// A locked meal is preserved when the week is regenerated.
    var isLocked: Bool

    var recipe: Recipe?
    /// Inverse relationship to the owning plan.
    var plan: MealPlan?

    init(
        id: UUID = UUID(),
        date: Date,
        mealType: MealType,
        servings: Int = 2,
        isLocked: Bool = false,
        recipe: Recipe? = nil
    ) {
        self.id = id
        self.date = date
        self.mealTypeRaw = mealType.rawValue
        self.servings = servings
        self.isLocked = isLocked
        self.recipe = recipe
    }
}

extension PlannedMeal {
    var mealType: MealType {
        get { MealType(rawValue: mealTypeRaw) ?? .dinner }
        set { mealTypeRaw = newValue.rawValue }
    }

    /// Nutrition scaled to the planned number of servings (per the recipe's base).
    var scaledNutrition: Nutrition {
        guard let recipe, recipe.servings > 0 else { return .zero }
        let perServing = recipe.nutrition.scaled(by: 1.0 / Double(recipe.servings))
        return perServing.scaled(by: Double(servings))
    }
}

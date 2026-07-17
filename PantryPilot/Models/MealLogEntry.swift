//
//  MealLogEntry.swift
//  PantryPilot
//
//  A record of a cooked/eaten meal, used to power the Statistics feature.
//

import Foundation
import SwiftData

@Model
final class MealLogEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var recipeTitle: String
    var mealTypeRaw: String
    var nutrition: Nutrition
    /// Cost attributed to this meal.
    var cost: Double
    /// Whether the user actually cooked this meal (vs. skipped).
    var wasCooked: Bool

    init(
        id: UUID = UUID(),
        date: Date = .now,
        recipeTitle: String,
        mealType: MealType,
        nutrition: Nutrition = .zero,
        cost: Double = 0,
        wasCooked: Bool = true
    ) {
        self.id = id
        self.date = date
        self.recipeTitle = recipeTitle
        self.mealTypeRaw = mealType.rawValue
        self.nutrition = nutrition
        self.cost = cost
        self.wasCooked = wasCooked
    }
}

extension MealLogEntry {
    var mealType: MealType {
        get { MealType(rawValue: mealTypeRaw) ?? .dinner }
        set { mealTypeRaw = newValue.rawValue }
    }
}

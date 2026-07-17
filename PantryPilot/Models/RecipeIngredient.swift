//
//  RecipeIngredient.swift
//  PantryPilot
//
//  A single ingredient line within a recipe.
//

import Foundation
import SwiftData

@Model
final class RecipeIngredient {
    var name: String
    var quantity: Double
    var unitRaw: String
    /// Optional note, e.g. "finely chopped".
    var note: String?
    var categoryRaw: String
    /// Whether this ingredient is optional in the recipe.
    var isOptional: Bool
    /// Sort index to preserve ingredient ordering.
    var sortIndex: Int

    /// Inverse relationship to the owning recipe.
    var recipe: Recipe?

    init(
        name: String,
        quantity: Double = 1,
        unit: MeasurementUnit = .pieces,
        note: String? = nil,
        category: ShoppingCategory = .other,
        isOptional: Bool = false,
        sortIndex: Int = 0
    ) {
        self.name = name
        self.quantity = quantity
        self.unitRaw = unit.rawValue
        self.note = note
        self.categoryRaw = category.rawValue
        self.isOptional = isOptional
        self.sortIndex = sortIndex
    }
}

extension RecipeIngredient {
    var unit: MeasurementUnit {
        get { MeasurementUnit(rawValue: unitRaw) ?? .pieces }
        set { unitRaw = newValue.rawValue }
    }

    var category: ShoppingCategory {
        get { ShoppingCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
}

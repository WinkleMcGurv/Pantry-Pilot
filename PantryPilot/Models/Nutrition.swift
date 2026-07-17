//
//  Nutrition.swift
//  PantryPilot
//
//  A lightweight value type describing the nutrition of a recipe or meal.
//  Stored inline on SwiftData models as a Codable attribute.
//

import Foundation

/// Per-serving nutrition facts.
struct Nutrition: Codable, Hashable, Sendable {
    var calories: Int
    /// Grams of protein.
    var protein: Double
    /// Grams of carbohydrate.
    var carbs: Double
    /// Grams of fat.
    var fat: Double

    init(calories: Int = 0, protein: Double = 0, carbs: Double = 0, fat: Double = 0) {
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }

    static let zero = Nutrition()

    /// Scales the nutrition by a serving multiplier.
    func scaled(by factor: Double) -> Nutrition {
        Nutrition(
            calories: Int((Double(calories) * factor).rounded()),
            protein: protein * factor,
            carbs: carbs * factor,
            fat: fat * factor
        )
    }

    static func + (lhs: Nutrition, rhs: Nutrition) -> Nutrition {
        Nutrition(
            calories: lhs.calories + rhs.calories,
            protein: lhs.protein + rhs.protein,
            carbs: lhs.carbs + rhs.carbs,
            fat: lhs.fat + rhs.fat
        )
    }
}

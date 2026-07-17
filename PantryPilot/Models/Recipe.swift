//
//  Recipe.swift
//  PantryPilot
//
//  A cookable recipe with ingredients, method, timings and nutrition.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var title: String
    var summary: String
    /// Remote image URL (recipes may also carry local image data).
    var imageURL: String?
    @Attribute(.externalStorage) var imageData: Data?

    /// Ordered preparation steps.
    var method: [String]
    /// Equipment required to cook the recipe.
    var equipment: [String]

    var prepTimeMinutes: Int
    var cookTimeMinutes: Int
    var servings: Int
    /// Estimated cost of the whole recipe in the user's currency.
    var estimatedCost: Double

    var nutrition: Nutrition
    var difficultyRaw: String
    var cuisineRaw: String?
    var mealTypesRaw: [String]
    var dietTagsRaw: [String]
    var allergensRaw: [String]

    var isFavourite: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.recipe)
    var ingredients: [RecipeIngredient]

    init(
        id: UUID = UUID(),
        title: String,
        summary: String = "",
        method: [String] = [],
        equipment: [String] = [],
        prepTimeMinutes: Int = 0,
        cookTimeMinutes: Int = 0,
        servings: Int = 2,
        estimatedCost: Double = 0,
        nutrition: Nutrition = .zero,
        difficulty: Difficulty = .easy,
        cuisine: Cuisine? = nil,
        mealTypes: [MealType] = [],
        dietTags: [DietaryPreference] = [],
        allergens: [Allergen] = [],
        ingredients: [RecipeIngredient] = []
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.method = method
        self.equipment = equipment
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.servings = servings
        self.estimatedCost = estimatedCost
        self.nutrition = nutrition
        self.difficultyRaw = difficulty.rawValue
        self.cuisineRaw = cuisine?.rawValue
        self.mealTypesRaw = mealTypes.map(\.rawValue)
        self.dietTagsRaw = dietTags.map(\.rawValue)
        self.allergensRaw = allergens.map(\.rawValue)
        self.isFavourite = false
        self.createdAt = .now
        self.ingredients = ingredients
    }
}

extension Recipe {
    var totalTimeMinutes: Int { prepTimeMinutes + cookTimeMinutes }

    var difficulty: Difficulty {
        get { Difficulty(rawValue: difficultyRaw) ?? .easy }
        set { difficultyRaw = newValue.rawValue }
    }

    var cuisine: Cuisine? {
        get { cuisineRaw.flatMap(Cuisine.init(rawValue:)) }
        set { cuisineRaw = newValue?.rawValue }
    }

    var mealTypes: [MealType] {
        get { mealTypesRaw.compactMap(MealType.init(rawValue:)) }
        set { mealTypesRaw = newValue.map(\.rawValue) }
    }

    var dietTags: [DietaryPreference] {
        get { dietTagsRaw.compactMap(DietaryPreference.init(rawValue:)) }
        set { dietTagsRaw = newValue.map(\.rawValue) }
    }

    var allergens: [Allergen] {
        get { allergensRaw.compactMap(Allergen.init(rawValue:)) }
        set { allergensRaw = newValue.map(\.rawValue) }
    }

    /// Estimated cost per serving.
    var costPerServing: Double {
        servings > 0 ? estimatedCost / Double(servings) : estimatedCost
    }
}

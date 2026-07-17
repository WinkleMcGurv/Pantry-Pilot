//
//  PreviewData.swift
//  PantryPilot
//
//  Sample data used only for SwiftUI previews and tests. This is illustrative
//  seed content — not production business logic.
//

import Foundation
import SwiftData

enum PreviewData {

    /// Inserts a small, representative data set into the given context.
    @MainActor
    static func populate(_ context: ModelContext) {
        let profile = UserProfile(name: "Alex", mealsPerDay: 3, householdSize: 2)
        profile.onboardingCompleted = true
        profile.dailyCalorieTarget = 2100
        profile.proteinTargetGrams = 140
        profile.weeklyBudget = 70
        context.insert(profile)

        for item in samplePantryItems() { context.insert(item) }

        let recipe = sampleRecipe()
        context.insert(recipe)

        try? context.save()
    }

    @MainActor
    static func samplePantryItems() -> [PantryItem] {
        [
            PantryItem(name: "Chicken breast", quantity: 500, unit: .grams,
                       storageLocation: .fridge, category: .meatAndFish,
                       expiryDate: Calendar.current.date(byAdding: .day, value: 2, to: .now)),
            PantryItem(name: "Basmati rice", quantity: 1, unit: .kilograms,
                       storageLocation: .pantry, category: .pantryStaples),
            PantryItem(name: "Cherry tomatoes", quantity: 300, unit: .grams,
                       storageLocation: .fridge, category: .produce,
                       expiryDate: Calendar.current.date(byAdding: .day, value: 5, to: .now))
        ]
    }

    @MainActor
    static func sampleRecipe() -> Recipe {
        Recipe(
            title: "Chicken & tomato rice bowl",
            summary: "A quick, high-protein weeknight bowl.",
            method: ["Cook the rice.", "Pan-fry the chicken.", "Combine and serve."],
            equipment: ["Frying pan", "Saucepan"],
            prepTimeMinutes: 10,
            cookTimeMinutes: 20,
            servings: 2,
            estimatedCost: 4.20,
            nutrition: Nutrition(calories: 520, protein: 42, carbs: 55, fat: 12),
            difficulty: .easy,
            cuisine: .british,
            mealTypes: [.dinner, .lunch],
            dietTags: [.highProtein],
            ingredients: [
                RecipeIngredient(name: "Chicken breast", quantity: 300, unit: .grams,
                                 category: .meatAndFish, sortIndex: 0),
                RecipeIngredient(name: "Basmati rice", quantity: 150, unit: .grams,
                                 category: .pantryStaples, sortIndex: 1),
                RecipeIngredient(name: "Cherry tomatoes", quantity: 150, unit: .grams,
                                 category: .produce, sortIndex: 2)
            ]
        )
    }
}

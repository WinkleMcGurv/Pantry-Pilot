//
//  UserProfile.swift
//  PantryPilot
//
//  The single user profile captured during onboarding. Multi-select preferences
//  are persisted as raw string arrays and exposed via typed accessors so the
//  schema stays stable while the UI works with enums.
//

import Foundation
import SwiftData

@Model
final class UserProfile {

    // MARK: Identity
    var name: String
    var createdAt: Date
    var onboardingCompleted: Bool

    // MARK: Body metrics
    var age: Int?
    /// Height in centimetres.
    var heightCm: Double?
    /// Weight in kilograms.
    var weightKg: Double?
    var activityLevelRaw: String
    var goalRaw: String

    // MARK: Nutrition targets
    var dailyCalorieTarget: Int?
    /// Daily protein target in grams.
    var proteinTargetGrams: Double?

    // MARK: Planning preferences
    /// Weekly grocery budget in the user's currency.
    var weeklyBudget: Double?
    var mealsPerDay: Int
    var cookingAbilityRaw: String
    /// Preferred maximum cooking time in minutes.
    var maxCookingTimeMinutes: Int
    var householdSize: Int

    // MARK: Taste & restrictions (stored as raw values)
    var favouriteCuisinesRaw: [String]
    var favouriteFoods: [String]
    var dislikedFoods: [String]
    var allergiesRaw: [String]
    var dietaryPreferencesRaw: [String]
    var preferredSupermarkets: [String]

    init(
        name: String = "",
        mealsPerDay: Int = 3,
        householdSize: Int = 1,
        maxCookingTimeMinutes: Int = 45,
        activityLevel: ActivityLevel = .moderate,
        goal: FitnessGoal = .maintain,
        cookingAbility: CookingAbility = .comfortable
    ) {
        self.name = name
        self.createdAt = .now
        self.onboardingCompleted = false
        self.mealsPerDay = mealsPerDay
        self.householdSize = householdSize
        self.maxCookingTimeMinutes = maxCookingTimeMinutes
        self.activityLevelRaw = activityLevel.rawValue
        self.goalRaw = goal.rawValue
        self.cookingAbilityRaw = cookingAbility.rawValue
        self.favouriteCuisinesRaw = []
        self.favouriteFoods = []
        self.dislikedFoods = []
        self.allergiesRaw = []
        self.dietaryPreferencesRaw = []
        self.preferredSupermarkets = []
    }
}

// MARK: - Typed accessors

extension UserProfile {
    var activityLevel: ActivityLevel {
        get { ActivityLevel(rawValue: activityLevelRaw) ?? .moderate }
        set { activityLevelRaw = newValue.rawValue }
    }

    var goal: FitnessGoal {
        get { FitnessGoal(rawValue: goalRaw) ?? .maintain }
        set { goalRaw = newValue.rawValue }
    }

    var cookingAbility: CookingAbility {
        get { CookingAbility(rawValue: cookingAbilityRaw) ?? .comfortable }
        set { cookingAbilityRaw = newValue.rawValue }
    }

    var favouriteCuisines: [Cuisine] {
        get { favouriteCuisinesRaw.compactMap(Cuisine.init(rawValue:)) }
        set { favouriteCuisinesRaw = newValue.map(\.rawValue) }
    }

    var allergies: [Allergen] {
        get { allergiesRaw.compactMap(Allergen.init(rawValue:)) }
        set { allergiesRaw = newValue.map(\.rawValue) }
    }

    var dietaryPreferences: [DietaryPreference] {
        get { dietaryPreferencesRaw.compactMap(DietaryPreference.init(rawValue:)) }
        set { dietaryPreferencesRaw = newValue.map(\.rawValue) }
    }
}

//
//  ModelEnums.swift
//  PantryPilot
//
//  Shared domain enumerations used across the data model and UI. All are
//  `String`-backed and `Codable` so they persist cleanly in SwiftData and are
//  stable across schema migrations.
//

import Foundation

/// The user's typical weekly activity level (drives calorie estimation later).
enum ActivityLevel: String, Codable, CaseIterable, Identifiable, Sendable {
    case sedentary, light, moderate, active, veryActive

    var id: String { rawValue }
    var title: String {
        switch self {
        case .sedentary:  return "Sedentary"
        case .light:      return "Lightly active"
        case .moderate:   return "Moderately active"
        case .active:     return "Active"
        case .veryActive: return "Very active"
        }
    }
}

/// The user's headline nutrition/fitness goal.
enum FitnessGoal: String, Codable, CaseIterable, Identifiable, Sendable {
    case lose, maintain, gain, recomposition

    var id: String { rawValue }
    var title: String {
        switch self {
        case .lose:          return "Lose weight"
        case .maintain:      return "Maintain"
        case .gain:          return "Build muscle"
        case .recomposition: return "Body recomposition"
        }
    }
}

/// Self-reported cooking confidence.
enum CookingAbility: String, Codable, CaseIterable, Identifiable, Sendable {
    case beginner, comfortable, advanced

    var id: String { rawValue }
    var title: String {
        switch self {
        case .beginner:    return "Beginner"
        case .comfortable: return "Comfortable"
        case .advanced:    return "Advanced"
        }
    }
}

/// A slot within a day's plan.
enum MealType: String, Codable, CaseIterable, Identifiable, Sendable {
    case breakfast, lunch, dinner, snack

    var id: String { rawValue }
    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch:     return "Lunch"
        case .dinner:    return "Dinner"
        case .snack:     return "Snack"
        }
    }

    var icon: AppIcon {
        switch self {
        case .breakfast: return .breakfast
        case .lunch:     return .lunch
        case .dinner:    return .dinner
        case .snack:     return .snack
        }
    }

    /// Canonical ordering within a day.
    var sortOrder: Int {
        switch self {
        case .breakfast: return 0
        case .lunch:     return 1
        case .dinner:    return 2
        case .snack:     return 3
        }
    }
}

/// Recipe difficulty.
enum Difficulty: String, Codable, CaseIterable, Identifiable, Sendable {
    case easy, medium, hard

    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}

/// Where a pantry item is stored.
enum StorageLocation: String, Codable, CaseIterable, Identifiable, Sendable {
    case pantry, fridge, freezer, spiceRack, other

    var id: String { rawValue }
    var title: String {
        switch self {
        case .pantry:    return "Pantry"
        case .fridge:    return "Fridge"
        case .freezer:   return "Freezer"
        case .spiceRack: return "Spice rack"
        case .other:     return "Other"
        }
    }
}

/// Units of measure for ingredients and pantry stock.
enum MeasurementUnit: String, Codable, CaseIterable, Identifiable, Sendable {
    case grams, kilograms, millilitres, litres, pieces, teaspoons, tablespoons, cups, cans, packs

    var id: String { rawValue }
    var abbreviation: String {
        switch self {
        case .grams:       return "g"
        case .kilograms:   return "kg"
        case .millilitres: return "ml"
        case .litres:      return "L"
        case .pieces:      return "pcs"
        case .teaspoons:   return "tsp"
        case .tablespoons: return "tbsp"
        case .cups:        return "cups"
        case .cans:        return "cans"
        case .packs:       return "packs"
        }
    }
}

/// Dietary preferences the planner must respect.
enum DietaryPreference: String, Codable, CaseIterable, Identifiable, Sendable {
    case none, vegetarian, vegan, pescatarian, keto, paleo, glutenFree, dairyFree, lowCarb, highProtein

    var id: String { rawValue }
    var title: String {
        switch self {
        case .none:        return "No preference"
        case .vegetarian:  return "Vegetarian"
        case .vegan:       return "Vegan"
        case .pescatarian: return "Pescatarian"
        case .keto:        return "Keto"
        case .paleo:       return "Paleo"
        case .glutenFree:  return "Gluten-free"
        case .dairyFree:   return "Dairy-free"
        case .lowCarb:     return "Low carb"
        case .highProtein: return "High protein"
        }
    }
}

/// Common allergens to exclude.
enum Allergen: String, Codable, CaseIterable, Identifiable, Sendable {
    case gluten, dairy, eggs, peanuts, treeNuts, soy, shellfish, fish, sesame

    var id: String { rawValue }
    var title: String {
        switch self {
        case .gluten:    return "Gluten"
        case .dairy:     return "Dairy"
        case .eggs:      return "Eggs"
        case .peanuts:   return "Peanuts"
        case .treeNuts:  return "Tree nuts"
        case .soy:       return "Soy"
        case .shellfish: return "Shellfish"
        case .fish:      return "Fish"
        case .sesame:    return "Sesame"
        }
    }
}

/// Cuisine styles for preferences and recipe tagging.
enum Cuisine: String, Codable, CaseIterable, Identifiable, Sendable {
    case british, italian, mexican, indian, chinese, japanese, thai, mediterranean, american, middleEastern, french, korean

    var id: String { rawValue }
    var title: String {
        switch self {
        case .british:       return "British"
        case .italian:       return "Italian"
        case .mexican:       return "Mexican"
        case .indian:        return "Indian"
        case .chinese:       return "Chinese"
        case .japanese:      return "Japanese"
        case .thai:          return "Thai"
        case .mediterranean: return "Mediterranean"
        case .american:      return "American"
        case .middleEastern: return "Middle Eastern"
        case .french:        return "French"
        case .korean:        return "Korean"
        }
    }
}

/// Supermarket aisle / category used to group shopping list items.
enum ShoppingCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case produce, meatAndFish, dairy, bakery, frozen, pantryStaples, drinks, household, other

    var id: String { rawValue }
    var title: String {
        switch self {
        case .produce:       return "Fruit & Vegetables"
        case .meatAndFish:   return "Meat & Fish"
        case .dairy:         return "Dairy & Eggs"
        case .bakery:        return "Bakery"
        case .frozen:        return "Frozen"
        case .pantryStaples: return "Pantry Staples"
        case .drinks:        return "Drinks"
        case .household:     return "Household"
        case .other:         return "Other"
        }
    }

    /// Ordering used when grouping a shopping list by aisle.
    var sortOrder: Int { Self.allCases.firstIndex(of: self) ?? 0 }
}

//
//  UnavailableServices.swift
//  PantryPilot
//
//  Honest placeholder implementations for capabilities not yet built. They
//  conform fully to their protocols and fail loudly with `AppError.notImplemented`
//  so the UI can present a clear "coming soon" state rather than silently doing
//  nothing. These are replaced by real engines in later phases.
//

import Foundation

/// Placeholder ``MealPlanningService`` until the AI planner lands (Phase 6/11).
struct UnavailableMealPlanningService: MealPlanningService {
    func generatePlan(_ request: MealPlanRequest) async throws -> MealPlan {
        throw AppError.notImplemented(feature: "AI meal planning")
    }

    func regenerateMeal(_ meal: PlannedMeal, in plan: MealPlan) async throws {
        throw AppError.notImplemented(feature: "AI meal planning")
    }
}

/// Placeholder ``AIAssistantService`` until AI integration lands (Phase 11).
struct UnavailableAIAssistantService: AIAssistantService {
    func suggestRecipes(fromPantry items: [PantryItem]) async throws -> [Recipe] {
        throw AppError.notImplemented(feature: "AI suggestions")
    }

    func substitutions(for ingredient: String) async throws -> [String] {
        throw AppError.notImplemented(feature: "AI substitutions")
    }

    func answer(question: String) async throws -> String {
        throw AppError.notImplemented(feature: "AI cooking assistant")
    }
}

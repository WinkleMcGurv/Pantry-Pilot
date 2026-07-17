//
//  MealPlanningService.swift
//  PantryPilot
//
//  The contract for generating and mutating weekly meal plans. The AI-backed
//  implementation is delivered in a later phase; the app depends only on this
//  protocol so the engine can be swapped without touching the UI.
//

import Foundation

/// Inputs that constrain plan generation.
struct MealPlanRequest {
    let weekStartDate: Date
    let mealsPerDay: Int
    let servingsPerMeal: Int
    /// Recipes/meals to preserve (locked) when regenerating.
    var lockedMealIDs: [UUID] = []
}

/// Generates and manipulates weekly meal plans.
protocol MealPlanningService {
    /// Generates a fresh plan for the given request.
    func generatePlan(_ request: MealPlanRequest) async throws -> MealPlan

    /// Regenerates a single meal slot within an existing plan.
    func regenerateMeal(_ meal: PlannedMeal, in plan: MealPlan) async throws
}

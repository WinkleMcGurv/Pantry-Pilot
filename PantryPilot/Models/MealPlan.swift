//
//  MealPlan.swift
//  PantryPilot
//
//  A week of planned meals. A plan can be marked as a saved favourite week.
//

import Foundation
import SwiftData

@Model
final class MealPlan {
    @Attribute(.unique) var id: UUID
    var title: String
    /// The Monday (start) of the plan week.
    var weekStartDate: Date
    var isFavourite: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \PlannedMeal.plan)
    var meals: [PlannedMeal]

    init(
        id: UUID = UUID(),
        title: String = "Weekly plan",
        weekStartDate: Date,
        isFavourite: Bool = false,
        meals: [PlannedMeal] = []
    ) {
        self.id = id
        self.title = title
        self.weekStartDate = weekStartDate
        self.isFavourite = isFavourite
        self.createdAt = .now
        self.meals = meals
    }
}

extension MealPlan {
    /// Total estimated cost of every planned meal in the week.
    var estimatedCost: Double {
        meals.reduce(0) { $0 + ($1.recipe?.estimatedCost ?? 0) }
    }

    /// Meals grouped and sorted by day.
    var mealsByDay: [Date: [PlannedMeal]] {
        Dictionary(grouping: meals) { Calendar.current.startOfDay(for: $0.date) }
    }
}

//
//  ShoppingList.swift
//  PantryPilot
//
//  A generated shopping list, optionally linked to a meal plan.
//

import Foundation
import SwiftData

@Model
final class ShoppingList {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date
    /// The meal plan this list was generated from, if any.
    var sourcePlanID: UUID?

    @Relationship(deleteRule: .cascade, inverse: \ShoppingListItem.list)
    var items: [ShoppingListItem]

    init(
        id: UUID = UUID(),
        title: String = "Shopping list",
        sourcePlanID: UUID? = nil,
        items: [ShoppingListItem] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = .now
        self.sourcePlanID = sourcePlanID
        self.items = items
    }
}

extension ShoppingList {
    var estimatedTotal: Double {
        items.reduce(0) { $0 + $1.estimatedCost }
    }

    var completedCount: Int {
        items.filter(\.isChecked).count
    }

    /// Items grouped by aisle, aisle order preserved.
    var itemsByCategory: [(category: ShoppingCategory, items: [ShoppingListItem])] {
        Dictionary(grouping: items, by: \.category)
            .sorted { $0.key.sortOrder < $1.key.sortOrder }
            .map { ($0.key, $0.value.sorted { $0.name < $1.name }) }
    }
}

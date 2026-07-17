//
//  ShoppingListItem.swift
//  PantryPilot
//
//  A single line on a shopping list.
//

import Foundation
import SwiftData

@Model
final class ShoppingListItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Double
    var unitRaw: String
    var categoryRaw: String
    var estimatedCost: Double
    var isChecked: Bool
    /// Whether the item is already covered by pantry stock.
    var isInPantry: Bool

    /// Inverse relationship to the owning list.
    var list: ShoppingList?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double = 1,
        unit: MeasurementUnit = .pieces,
        category: ShoppingCategory = .other,
        estimatedCost: Double = 0,
        isChecked: Bool = false,
        isInPantry: Bool = false
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unitRaw = unit.rawValue
        self.categoryRaw = category.rawValue
        self.estimatedCost = estimatedCost
        self.isChecked = isChecked
        self.isInPantry = isInPantry
    }
}

extension ShoppingListItem {
    var unit: MeasurementUnit {
        get { MeasurementUnit(rawValue: unitRaw) ?? .pieces }
        set { unitRaw = newValue.rawValue }
    }

    var category: ShoppingCategory {
        get { ShoppingCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
}

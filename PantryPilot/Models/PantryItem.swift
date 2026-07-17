//
//  PantryItem.swift
//  PantryPilot
//
//  A single ingredient the user currently has in stock.
//

import Foundation
import SwiftData

@Model
final class PantryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Double
    var unitRaw: String
    var storageLocationRaw: String
    var expiryDate: Date?
    var barcode: String?
    /// Optional photo stored externally to keep the store lean.
    @Attribute(.externalStorage) var photoData: Data?
    var categoryRaw: String
    var dateAdded: Date

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double = 1,
        unit: MeasurementUnit = .pieces,
        storageLocation: StorageLocation = .pantry,
        category: ShoppingCategory = .other,
        expiryDate: Date? = nil,
        barcode: String? = nil,
        photoData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unitRaw = unit.rawValue
        self.storageLocationRaw = storageLocation.rawValue
        self.categoryRaw = category.rawValue
        self.expiryDate = expiryDate
        self.barcode = barcode
        self.photoData = photoData
        self.dateAdded = .now
    }
}

extension PantryItem {
    var unit: MeasurementUnit {
        get { MeasurementUnit(rawValue: unitRaw) ?? .pieces }
        set { unitRaw = newValue.rawValue }
    }

    var storageLocation: StorageLocation {
        get { StorageLocation(rawValue: storageLocationRaw) ?? .pantry }
        set { storageLocationRaw = newValue.rawValue }
    }

    var category: ShoppingCategory {
        get { ShoppingCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    /// Whole calendar days until expiry (0 = today, negative = expired), or
    /// `nil` if no expiry date is set. Day-granular because expiry is picked
    /// as a date, not a time.
    var daysUntilExpiry: Int? {
        guard let expiryDate else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: .now),
            to: calendar.startOfDay(for: expiryDate)
        ).day
    }

    /// Whether the item expires within the next three days.
    var isExpiringSoon: Bool {
        guard let days = daysUntilExpiry else { return false }
        return days <= 3
    }
}

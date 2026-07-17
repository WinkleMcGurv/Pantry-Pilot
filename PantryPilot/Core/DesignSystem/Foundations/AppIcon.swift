//
//  AppIcon.swift
//  PantryPilot
//
//  Centralised SF Symbol names. Referencing icons through this enum keeps
//  iconography consistent and makes a global swap trivial.
//

import SwiftUI

/// Semantic icon set backed by SF Symbols.
enum AppIcon: String {
    // Navigation / tabs
    case planner = "calendar"
    case pantry = "cabinet"
    case recipes = "book.pages"
    case shopping = "cart"
    case stats = "chart.bar.xaxis"

    // Sections
    case budget = "creditcard"
    case calendar = "calendar.day.timeline.left"
    case assistant = "sparkles"
    case settings = "gearshape"
    case profile = "person.crop.circle"
    case notifications = "bell"

    // Meals
    case breakfast = "sunrise"
    case lunch = "sun.max"
    case dinner = "moon.stars"
    case snack = "carrot"

    // Actions
    case add = "plus"
    case edit = "pencil"
    case delete = "trash"
    case lock = "lock"
    case unlock = "lock.open"
    case swap = "arrow.left.arrow.right"
    case regenerate = "arrow.triangle.2.circlepath"
    case duplicate = "plus.square.on.square"
    case favourite = "heart"
    case favouriteFilled = "heart.fill"
    case share = "square.and.arrow.up"
    case search = "magnifyingglass"
    case filter = "line.3.horizontal.decrease.circle"
    case barcode = "barcode.viewfinder"
    case camera = "camera"
    case checkmark = "checkmark"
    case chevronRight = "chevron.right"
    case chevronLeft = "chevron.left"
    case close = "xmark"

    // States
    case expiry = "clock.badge.exclamationmark"
    case warning = "exclamationmark.triangle"
    case empty = "tray"

    /// A SwiftUI `Image` for this symbol.
    var image: Image { Image(systemName: rawValue) }

    /// The raw SF Symbol name (for `Label`, `Image(systemName:)`, etc.).
    var symbol: String { rawValue }
}

extension Label where Title == Text, Icon == Image {
    /// Convenience `Label` using an `AppIcon`.
    init(_ title: String, icon: AppIcon) {
        self.init(title, systemImage: icon.rawValue)
    }
}

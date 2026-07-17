//
//  AppTab.swift
//  PantryPilot
//
//  The top-level tabs of the app.
//

import SwiftUI

/// The five primary sections surfaced in the tab bar.
enum AppTab: String, CaseIterable, Identifiable, Hashable {
    case planner
    case pantry
    case recipes
    case shopping
    case stats

    var id: String { rawValue }

    var title: String {
        switch self {
        case .planner:  return "Planner"
        case .pantry:   return "Pantry"
        case .recipes:  return "Recipes"
        case .shopping: return "Shopping"
        case .stats:    return "Stats"
        }
    }

    var icon: AppIcon {
        switch self {
        case .planner:  return .planner
        case .pantry:   return .pantry
        case .recipes:  return .recipes
        case .shopping: return .shopping
        case .stats:    return .stats
        }
    }
}

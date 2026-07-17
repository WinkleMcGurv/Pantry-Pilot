//
//  ThemeManager.swift
//  PantryPilot
//
//  Owns the user's appearance preference (system / light / dark) and persists
//  it. Applied at the root via `.preferredColorScheme(themeManager.colorScheme)`.
//

import SwiftUI
import Observation

/// User-selectable appearance mode.
enum AppearanceMode: String, CaseIterable, Codable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

/// Observable store for the app's appearance preference.
@Observable
final class ThemeManager {

    /// Persisted key for the selected appearance mode.
    private static let storageKey = "settings.appearanceMode"

    var appearance: AppearanceMode {
        didSet { UserDefaults.standard.set(appearance.rawValue, forKey: Self.storageKey) }
    }

    /// The colour scheme to force, or `nil` to follow the system.
    var colorScheme: ColorScheme? { appearance.colorScheme }

    init(userDefaults: UserDefaults = .standard) {
        let raw = userDefaults.string(forKey: Self.storageKey)
        self.appearance = raw.flatMap(AppearanceMode.init(rawValue:)) ?? .system
    }
}

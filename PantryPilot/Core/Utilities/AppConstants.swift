//
//  AppConstants.swift
//  PantryPilot
//
//  Global constants and configuration values.
//

import Foundation

enum AppConstants {
    static let appName = "PantryPilot"

    /// Default currency code used for cost/budget formatting.
    static let currencyCode = "GBP"

    /// Number of days shown in the weekly planner.
    static let daysPerWeek = 7

    enum UserDefaultsKey {
        static let appearanceMode = "settings.appearanceMode"
        static let onboardingCompleted = "app.onboardingCompleted"
    }
}

//
//  Formatters.swift
//  PantryPilot
//
//  Shared, cached formatters and formatting helpers.
//

import Foundation

enum AppFormat {

    /// Formats a monetary amount using the app's currency.
    static func currency(_ amount: Double) -> String {
        amount.formatted(.currency(code: AppConstants.currencyCode))
    }

    /// Formats a whole-number calorie value, e.g. "1,840 kcal".
    static func calories(_ value: Int) -> String {
        "\(value.formatted()) kcal"
    }

    /// Formats a macronutrient gram value, e.g. "42 g".
    static func grams(_ value: Double) -> String {
        "\(value.formatted(.number.precision(.fractionLength(0...1)))) g"
    }

    /// Formats a duration in minutes as "1 hr 5 min" / "25 min".
    static func minutes(_ total: Int) -> String {
        guard total >= 60 else { return "\(total) min" }
        let hours = total / 60
        let mins = total % 60
        return mins == 0 ? "\(hours) hr" : "\(hours) hr \(mins) min"
    }

    /// A short weekday + day formatter, e.g. "Mon 21".
    static func shortDay(_ date: Date) -> String {
        date.formatted(.dateTime.weekday(.abbreviated).day())
    }
}

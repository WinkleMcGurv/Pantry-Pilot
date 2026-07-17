//
//  AppColor.swift
//  PantryPilot
//
//  The semantic colour system. Colours are defined in code as light/dark pairs
//  so the palette is fully version-controlled, testable, and guaranteed to adapt
//  to the active colour scheme without touching the asset catalog.
//

import SwiftUI
import UIKit

/// Namespace for every semantic colour used across the app.
///
/// Prefer these semantic tokens (`AppColor.brand`, `AppColor.surface`, …) over
/// raw `Color(...)` values so the design language stays consistent and a single
/// change here re-themes the entire product.
enum AppColor {

    // MARK: Brand

    /// Primary brand colour — used for key actions and identity.
    static let brand = dynamic(light: 0x228B5E, dark: 0x3FBF87)
    /// A softer brand tint for large fills, selected states and backgrounds.
    static let brandSoft = dynamic(light: 0xDCEFE5, dark: 0x1C3A2C)
    /// Warm accent used sparingly to draw the eye (appetite / energy).
    static let accent = dynamic(light: 0xE17B4B, dark: 0xF2955F)
    static let accentSoft = dynamic(light: 0xFBEADF, dark: 0x3A281C)

    // MARK: Surfaces & backgrounds

    /// App background, behind all content.
    static let background = dynamic(light: 0xF6F7F4, dark: 0x0E1512)
    /// Primary card / grouped-content surface.
    static let surface = dynamic(light: 0xFFFFFF, dark: 0x18201B)
    /// A raised surface for stacked cards, sheets and popovers.
    static let surfaceElevated = dynamic(light: 0xFFFFFF, dark: 0x222B25)
    /// Subtle fill for inputs, chips and secondary controls.
    static let fill = dynamic(light: 0xEEF0EC, dark: 0x2A332D)

    // MARK: Text

    static let textPrimary = dynamic(light: 0x14201A, dark: 0xEAF2EC)
    static let textSecondary = dynamic(light: 0x5C6B63, dark: 0x9FB0A6)
    static let textTertiary = dynamic(light: 0x93A199, dark: 0x6E7F76)
    /// Text/icon colour intended to sit on top of the brand colour.
    static let onBrand = dynamic(light: 0xFFFFFF, dark: 0x08120C)

    // MARK: Lines

    static let separator = dynamic(light: 0xE4E7E2, dark: 0x2E382F)
    static let border = dynamic(light: 0xD8DCD5, dark: 0x384038)

    // MARK: Status

    static let success = dynamic(light: 0x2E9E63, dark: 0x4FD08A)
    static let warning = dynamic(light: 0xE0A008, dark: 0xF5C445)
    static let error = dynamic(light: 0xD64545, dark: 0xF07070)
    static let info = dynamic(light: 0x3E7BFA, dark: 0x6E9BFF)

    // MARK: Nutrition / macro accents

    /// Consistent colours for calories & macronutrients used across charts,
    /// rings and stat tiles so the same nutrient always reads the same colour.
    enum Macro {
        static let calories = dynamic(light: 0xE17B4B, dark: 0xF2955F)
        static let protein = dynamic(light: 0x4C6EF5, dark: 0x7C96FF)
        static let carbs = dynamic(light: 0xE0A008, dark: 0xF5C445)
        static let fat = dynamic(light: 0xA06BE0, dark: 0xC79CF0)
    }

    // MARK: Construction

    /// Builds a `Color` that resolves differently in light and dark mode.
    /// - Parameters:
    ///   - light: 24-bit RGB hex used in light appearance.
    ///   - dark: 24-bit RGB hex used in dark appearance.
    static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(rgb: dark) : UIColor(rgb: light)
        })
    }
}

extension UIColor {
    /// Creates an opaque colour from a 24-bit `0xRRGGBB` value.
    fileprivate convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}

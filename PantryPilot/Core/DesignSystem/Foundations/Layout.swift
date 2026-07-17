//
//  Layout.swift
//  PantryPilot
//
//  Corner radii, control sizing and elevation tokens.
//

import SwiftUI

/// Corner-radius scale.
enum AppRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    /// Fully rounded (pills / circular controls).
    static let pill: CGFloat = 999
}

/// Standard control and element sizing.
enum AppSize {
    /// Minimum tappable dimension per Apple HIG (44pt).
    static let minTapTarget: CGFloat = 44
    static let controlHeight: CGFloat = 52
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 22
    static let iconLarge: CGFloat = 28
    static let avatar: CGFloat = 40
}

/// Elevation / shadow tokens applied via ``AppShadow/apply(_:)`` style helpers.
enum AppShadow {
    case none
    case soft
    case elevated

    var color: Color {
        switch self {
        case .none:     return .clear
        case .soft:     return .black.opacity(0.06)
        case .elevated: return .black.opacity(0.12)
        }
    }

    var radius: CGFloat {
        switch self {
        case .none:     return 0
        case .soft:     return 10
        case .elevated: return 20
        }
    }

    var y: CGFloat {
        switch self {
        case .none:     return 0
        case .soft:     return 4
        case .elevated: return 10
        }
    }
}

extension View {
    /// Applies a semantic elevation shadow.
    func appShadow(_ shadow: AppShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: 0, y: shadow.y)
    }
}

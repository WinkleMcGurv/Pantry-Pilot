//
//  Spacing.swift
//  PantryPilot
//
//  The spacing scale. A single source of truth for padding, stack spacing and
//  gaps keeps vertical and horizontal rhythm consistent everywhere.
//

import CoreGraphics

/// 4-point based spacing scale.
enum AppSpacing {
    /// 2pt — hairline gaps.
    static let xxs: CGFloat = 2
    /// 4pt
    static let xs: CGFloat = 4
    /// 8pt
    static let sm: CGFloat = 8
    /// 12pt
    static let md: CGFloat = 12
    /// 16pt — the default content inset.
    static let lg: CGFloat = 16
    /// 20pt
    static let xl: CGFloat = 20
    /// 24pt
    static let xxl: CGFloat = 24
    /// 32pt
    static let xxxl: CGFloat = 32
    /// 48pt — large section separation.
    static let huge: CGFloat = 48

    /// The standard horizontal screen inset for scrollable content.
    static let screenEdge: CGFloat = 16
}

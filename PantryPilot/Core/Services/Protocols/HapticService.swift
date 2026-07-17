//
//  HapticService.swift
//  PantryPilot
//
//  Abstraction over haptic feedback so features can trigger haptics without
//  touching UIKit directly (and so it can be no-op'd in tests).
//

import Foundation

enum HapticStyle {
    case light, medium, heavy
    case success, warning, error
    case selection
}

/// Provides haptic feedback.
@MainActor
protocol HapticService {
    func play(_ style: HapticStyle)
}

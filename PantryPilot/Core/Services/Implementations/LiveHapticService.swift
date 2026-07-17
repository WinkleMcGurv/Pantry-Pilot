//
//  LiveHapticService.swift
//  PantryPilot
//
//  UIKit-backed haptic feedback.
//

import UIKit

/// Concrete ``HapticService`` using `UIFeedbackGenerator`.
@MainActor
final class LiveHapticService: HapticService {

    func play(_ style: HapticStyle) {
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}

/// A no-op ``HapticService`` for previews and tests.
@MainActor
final class NoopHapticService: HapticService {
    func play(_ style: HapticStyle) {}
}

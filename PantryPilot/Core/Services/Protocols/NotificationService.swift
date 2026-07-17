//
//  NotificationService.swift
//  PantryPilot
//
//  Abstraction over local notification scheduling (meal, shopping, expiry and
//  meal-prep reminders). Feature-specific scheduling logic is added later; this
//  layer provides the generic authorisation + schedule/cancel plumbing.
//

import Foundation

/// A local notification request to be scheduled.
struct LocalNotificationRequest {
    let id: String
    let title: String
    let body: String
    let date: Date
    var repeats: Bool = false
}

/// Schedules and manages local notifications.
protocol NotificationService {
    /// Requests notification authorisation from the user.
    /// - Returns: `true` if authorisation was granted.
    @discardableResult
    func requestAuthorisation() async -> Bool

    /// Schedules a local notification.
    func schedule(_ request: LocalNotificationRequest) async throws

    /// Cancels a scheduled notification by identifier.
    func cancel(id: String)

    /// Cancels every pending notification.
    func cancelAll()
}

//
//  LocalNotificationService.swift
//  PantryPilot
//
//  `UserNotifications`-backed implementation of ``NotificationService``.
//

import Foundation
import UserNotifications

/// Concrete notification service using `UNUserNotificationCenter`.
final class LocalNotificationService: NotificationService {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    @discardableResult
    func requestAuthorisation() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            AppLogger.services.error("Notification authorisation failed: \(error.localizedDescription)")
            return false
        }
    }

    func schedule(_ request: LocalNotificationRequest) async throws {
        let content = UNMutableNotificationContent()
        content.title = request.title
        content.body = request.body
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: request.date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: request.repeats)
        let notification = UNNotificationRequest(identifier: request.id, content: content, trigger: trigger)
        try await center.add(notification)
    }

    func cancel(id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}

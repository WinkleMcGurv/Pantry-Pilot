//
//  AppContainer.swift
//  PantryPilot
//
//  The composition root / dependency-injection container. Owns the SwiftData
//  container and every shared service, and is injected into the SwiftUI
//  environment so features resolve their dependencies from one place.
//

import SwiftUI
import SwiftData
import Observation

/// Application-wide dependency container.
///
/// Access it in views via `@Environment(AppContainer.self)`.
@MainActor
@Observable
final class AppContainer {

    // MARK: Persistence
    let modelContainer: ModelContainer
    let dataStore: DataStore

    // MARK: Services
    let haptics: HapticService
    let notifications: NotificationService
    let mealPlanning: MealPlanningService
    let aiAssistant: AIAssistantService

    // MARK: App-wide state
    let theme: ThemeManager

    init(
        modelContainer: ModelContainer,
        haptics: HapticService,
        notifications: NotificationService,
        mealPlanning: MealPlanningService,
        aiAssistant: AIAssistantService,
        theme: ThemeManager
    ) {
        self.modelContainer = modelContainer
        self.dataStore = SwiftDataStore(context: modelContainer.mainContext)
        self.haptics = haptics
        self.notifications = notifications
        self.mealPlanning = mealPlanning
        self.aiAssistant = aiAssistant
        self.theme = theme
    }

    /// The live container wired with production services.
    static func live() -> AppContainer {
        AppContainer(
            modelContainer: PersistenceController.makeContainer(),
            haptics: LiveHapticService(),
            notifications: LocalNotificationService(),
            mealPlanning: UnavailableMealPlanningService(),
            aiAssistant: UnavailableAIAssistantService(),
            theme: ThemeManager()
        )
    }

    /// An in-memory container with sample data for previews.
    static func preview() -> AppContainer {
        AppContainer(
            modelContainer: PersistenceController.preview,
            haptics: NoopHapticService(),
            notifications: LocalNotificationService(),
            mealPlanning: UnavailableMealPlanningService(),
            aiAssistant: UnavailableAIAssistantService(),
            theme: ThemeManager()
        )
    }
}

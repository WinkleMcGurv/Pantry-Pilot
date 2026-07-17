//
//  RootView.swift
//  PantryPilot
//
//  Decides between onboarding and the main app based on whether a completed
//  user profile exists, and owns the app-wide router.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AppContainer.self) private var container
    @Query private var profiles: [UserProfile]
    @State private var router = AppRouter()

    private var hasCompletedOnboarding: Bool {
        profiles.contains { $0.onboardingCompleted }
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
                    .environment(router)
            } else {
                OnboardingView(onFinished: {})
            }
        }
        .animation(.default, value: hasCompletedOnboarding)
        .preferredColorScheme(container.theme.colorScheme)
    }
}

#Preview("Onboarding") {
    RootView()
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.makeContainer(inMemory: true))
}

#Preview("Main") {
    RootView()
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.preview)
}

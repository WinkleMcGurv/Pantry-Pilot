//
//  OnboardingView.swift
//  PantryPilot
//
//  Welcome / onboarding gate. The full multi-step questionnaire is built in
//  Phase 4; for now this establishes the gate and lets the user enter the app by
//  creating a minimal profile so the rest of the navigation is testable.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppContainer.self) private var container

    /// Called once a profile exists and onboarding is marked complete.
    let onFinished: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()

            VStack(spacing: AppSpacing.lg) {
                AppIcon.recipes.image
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(AppColor.onBrand)
                    .frame(width: 112, height: 112)
                    .background(AppColor.brand, in: RoundedRectangle(cornerRadius: AppRadius.xl, style: .continuous))

                VStack(spacing: AppSpacing.sm) {
                    Text("Welcome to PantryPilot")
                        .appFont(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text("Effortless weekly meal plans that use what you already have, hit your goals and save money.")
                        .appFont(.body)
                        .foregroundStyle(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()

            VStack(spacing: AppSpacing.sm) {
                PPButton("Get started", icon: .checkmark) { finish() }
                Text("The full setup questionnaire arrives in Phase 4.")
                    .appFont(.caption)
                    .foregroundStyle(AppColor.textTertiary)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }

    private func finish() {
        container.haptics.play(.success)
        let profile = fetchOrCreateProfile()
        profile.onboardingCompleted = true
        try? context.save()
        onFinished()
    }

    private func fetchOrCreateProfile() -> UserProfile {
        let descriptor = FetchDescriptor<UserProfile>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        let profile = UserProfile()
        context.insert(profile)
        return profile
    }
}

#Preview {
    OnboardingView(onFinished: {})
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.preview)
}

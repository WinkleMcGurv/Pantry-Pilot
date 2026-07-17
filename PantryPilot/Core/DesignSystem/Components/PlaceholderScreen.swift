//
//  PlaceholderScreen.swift
//  PantryPilot
//
//  A reusable "coming soon" scaffold. Every feature ships a real screen backed
//  by this component during the architecture phase so navigation can be fully
//  exercised before business logic is implemented.
//

import SwiftUI

/// A branded placeholder used for not-yet-implemented feature screens.
struct PlaceholderScreen: View {
    let icon: AppIcon
    let title: String
    let message: String
    /// The development phase this feature is scheduled for (shown as a badge).
    var phase: String?

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                if let phase {
                    PPBadge(text: phase, icon: .calendar, tone: .brand)
                        .padding(.top, AppSpacing.xl)
                }
                EmptyStateView(icon: icon, title: title, message: message)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.screenEdge)
        }
        .background(AppColor.background)
    }
}

#Preview {
    NavigationStack {
        PlaceholderScreen(
            icon: .planner,
            title: "Meal Planner",
            message: "Your AI-generated weekly plan will live here.",
            phase: "Phase 6"
        )
        .navigationTitle("Planner")
    }
}

//
//  PlannerView.swift
//  PantryPilot
//
//  Root of the Planner tab. Placeholder for the AI weekly meal planner. Wires
//  navigation to Budget, Calendar and Meal-Prep so routing can be tested now.
//

import SwiftUI

struct PlannerView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                PlaceholderScreen(
                    icon: .planner,
                    title: "Weekly Meal Planner",
                    message: "Generate an intelligent weekly plan for breakfast, lunch, dinner and snacks.",
                    phase: "Phase 6"
                )
                .frame(minHeight: 320)

                VStack(spacing: AppSpacing.sm) {
                    NavigationLink(value: AppRoute.calendar) {
                        navRow(icon: .calendar, title: "Calendar", subtitle: "Weekly & monthly view")
                    }
                    NavigationLink(value: AppRoute.mealPrep) {
                        navRow(icon: .calendar, title: "Meal Prep Mode", subtitle: "Batch cooking")
                    }
                    NavigationLink(value: AppRoute.budget) {
                        navRow(icon: .budget, title: "Budget", subtitle: "Spend & savings")
                    }
                }
                .screenPadding()
            }
            .padding(.vertical, AppSpacing.lg)
        }
        .background(AppColor.background)
        .navigationTitle("Planner")
        .rootToolbar()
    }

    private func navRow(icon: AppIcon, title: String, subtitle: String) -> some View {
        HStack(spacing: AppSpacing.md) {
            icon.image
                .foregroundStyle(AppColor.brand)
                .frame(width: AppSize.iconLarge)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).appFont(.bodyEmphasised).foregroundStyle(AppColor.textPrimary)
                Text(subtitle).appFont(.footnote).foregroundStyle(AppColor.textSecondary)
            }
            Spacer()
            AppIcon.chevronRight.image.foregroundStyle(AppColor.textTertiary)
        }
        .cardStyle()
    }
}

#Preview {
    NavigationStack {
        PlannerView()
    }
    .environment(AppRouter())
    .environment(AppContainer.preview())
}

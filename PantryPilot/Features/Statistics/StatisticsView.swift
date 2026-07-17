//
//  StatisticsView.swift
//  PantryPilot
//
//  Root of the Stats tab. Placeholder for the statistics dashboard.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                PlaceholderScreen(
                    icon: .stats,
                    title: "Statistics",
                    message: "Track calories, macros, grocery spend, food-waste reduction and meals cooked.",
                    phase: "Phase 9"
                )
                .frame(minHeight: 320)

                NavigationLink(value: AppRoute.statisticsDetail) {
                    PPButton("Preview statistics detail", icon: .chevronRight, variant: .secondary) {}
                        .allowsHitTesting(false)
                }
                .screenPadding()
            }
            .padding(.vertical, AppSpacing.lg)
        }
        .background(AppColor.background)
        .navigationTitle("Statistics")
        .rootToolbar()
    }
}

#Preview {
    NavigationStack { StatisticsView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
}

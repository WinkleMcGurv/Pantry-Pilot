//
//  ShoppingListView.swift
//  PantryPilot
//
//  Root of the Shopping tab. Placeholder for auto-generated shopping lists.
//

import SwiftUI

struct ShoppingListView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                PlaceholderScreen(
                    icon: .shopping,
                    title: "Shopping Lists",
                    message: "Auto-generated lists that merge duplicates, group by aisle and tick off as you shop.",
                    phase: "Phase 8"
                )
                .frame(minHeight: 320)

                NavigationLink(value: AppRoute.shoppingListDetail(listID: UUID())) {
                    PPButton("Preview list detail", icon: .chevronRight, variant: .secondary) {}
                        .allowsHitTesting(false)
                }
                .screenPadding()
            }
            .padding(.vertical, AppSpacing.lg)
        }
        .background(AppColor.background)
        .navigationTitle("Shopping")
        .rootToolbar()
    }
}

#Preview {
    NavigationStack { ShoppingListView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
}

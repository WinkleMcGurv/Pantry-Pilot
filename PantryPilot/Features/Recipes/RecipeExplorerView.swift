//
//  RecipeExplorerView.swift
//  PantryPilot
//
//  Root of the Recipes tab. Placeholder for recipe search & filtering, wired to
//  the recipe-detail route.
//

import SwiftUI

struct RecipeExplorerView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                PlaceholderScreen(
                    icon: .recipes,
                    title: "Recipe Explorer",
                    message: "Search and filter recipes by calories, protein, budget, cuisine, time, difficulty and diet.",
                    phase: "Phase 6"
                )
                .frame(minHeight: 320)

                NavigationLink(value: AppRoute.recipeDetail(recipeID: UUID())) {
                    PPButton("Preview recipe detail", icon: .chevronRight, variant: .secondary) {}
                        .allowsHitTesting(false)
                }
                .screenPadding()
            }
            .padding(.vertical, AppSpacing.lg)
        }
        .background(AppColor.background)
        .navigationTitle("Recipes")
        .rootToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { } label: { AppIcon.filter.image }
                    .accessibilityLabel("Filter recipes")
            }
        }
    }
}

#Preview {
    NavigationStack { RecipeExplorerView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
}

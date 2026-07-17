//
//  PantryView.swift
//  PantryPilot
//
//  Root of the Pantry tab. Placeholder for the ingredient inventory.
//

import SwiftUI

struct PantryView: View {
    var body: some View {
        PlaceholderScreen(
            icon: .pantry,
            title: "Your Pantry",
            message: "Track ingredients, quantities, expiry dates and storage so the planner can cook from what you already have.",
            phase: "Phase 5"
        )
        .navigationTitle("Pantry")
        .rootToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { } label: { AppIcon.add.image }
                    .accessibilityLabel("Add ingredient")
            }
        }
    }
}

#Preview {
    NavigationStack { PantryView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
}

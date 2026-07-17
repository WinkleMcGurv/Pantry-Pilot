//
//  ProfileView.swift
//  PantryPilot
//
//  Profile & preferences sheet. Placeholder until onboarding data is editable.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        PlaceholderScreen(
            icon: .profile,
            title: "Profile & Preferences",
            message: "Review and edit the details captured during onboarding — goals, budget, cuisines, allergies and more.",
            phase: "Phase 4"
        )
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environment(AppContainer.preview())
}

//
//  AssistantView.swift
//  PantryPilot
//
//  AI cooking assistant sheet. Placeholder until AI integration (Phase 11).
//

import SwiftUI

struct AssistantView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        PlaceholderScreen(
            icon: .assistant,
            title: "AI Assistant",
            message: "Ask for pantry recipe ideas, ingredient swaps, nutrition advice and step-by-step cooking help.",
            phase: "Phase 11"
        )
        .navigationTitle("Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack { AssistantView() }
        .environment(AppContainer.preview())
}

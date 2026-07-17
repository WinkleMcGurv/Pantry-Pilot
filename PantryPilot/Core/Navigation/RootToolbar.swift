//
//  RootToolbar.swift
//  PantryPilot
//
//  Shared toolbar for tab-root screens: quick access to the AI assistant and
//  settings via the app router.
//

import SwiftUI

private struct RootToolbarModifier: ViewModifier {
    @Environment(AppRouter.self) private var router

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.present(.assistant)
                } label: {
                    AppIcon.assistant.image
                }
                .accessibilityLabel("AI assistant")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.present(.settings)
                } label: {
                    AppIcon.settings.image
                }
                .accessibilityLabel("Settings")
            }
        }
    }
}

extension View {
    /// Adds the shared root-screen toolbar (assistant + settings).
    func rootToolbar() -> some View {
        modifier(RootToolbarModifier())
    }
}

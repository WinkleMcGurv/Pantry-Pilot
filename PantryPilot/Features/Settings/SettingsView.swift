//
//  SettingsView.swift
//  PantryPilot
//
//  Settings sheet. The appearance picker is fully functional to demonstrate the
//  theming pipeline; the remaining rows are placeholders for later phases.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppContainer.self) private var container
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var theme = container.theme

        Form {
            Section("Appearance") {
                Picker("Theme", selection: $theme.appearance) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Account") {
                Button {
                    dismiss()
                    router.present(.profile)
                } label: {
                    Label("Profile & preferences", icon: .profile)
                }
                Button {
                    dismiss()
                    router.present(.notifications)
                } label: {
                    Label("Notifications", icon: .notifications)
                }
            }

            Section("About") {
                LabeledContent("Version", value: appVersion)
                LabeledContent("Build", value: "Architecture foundation")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0"
    }
}

#Preview {
    NavigationStack { SettingsView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
}

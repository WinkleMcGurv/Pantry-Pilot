//
//  PantryPilotApp.swift
//  PantryPilot
//
//  Application entry point. Builds the dependency container, installs the
//  SwiftData model container and the DI container into the environment, and
//  shows the root view.
//

import SwiftUI

@main
struct PantryPilotApp: App {
    @State private var container = AppContainer.live()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
                .modelContainer(container.modelContainer)
                .tint(AppColor.brand)
        }
    }
}

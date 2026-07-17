//
//  AppRouter.swift
//  PantryPilot
//
//  App-wide navigation coordinator. Owns the selected tab, a navigation path
//  per tab, and the currently presented sheet. Injected via the environment so
//  any view can drive navigation without prop-drilling bindings.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class AppRouter {

    /// The currently selected tab.
    var selectedTab: AppTab = .planner

    /// A separate navigation path for each tab so back-stacks are preserved
    /// when switching tabs.
    var paths: [AppTab: [AppRoute]] = [:]

    /// The globally presented sheet, if any.
    var presentedSheet: AppSheet?

    /// Binding to the path for a given tab, for use with `NavigationStack`.
    func path(for tab: AppTab) -> Binding<[AppRoute]> {
        Binding(
            get: { self.paths[tab] ?? [] },
            set: { self.paths[tab] = $0 }
        )
    }

    /// Pushes a route onto the currently selected tab's stack.
    func push(_ route: AppRoute) {
        paths[selectedTab, default: []].append(route)
    }

    /// Pops to the root of the selected tab.
    func popToRoot() {
        paths[selectedTab] = []
    }

    /// Presents a modal sheet.
    func present(_ sheet: AppSheet) {
        presentedSheet = sheet
    }
}

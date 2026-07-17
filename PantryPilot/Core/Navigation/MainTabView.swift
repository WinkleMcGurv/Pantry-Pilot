//
//  MainTabView.swift
//  PantryPilot
//
//  The root tab container. Each tab hosts its own `NavigationStack` bound to the
//  router's per-tab path, and shared sheets (settings, profile, assistant) are
//  presented at this level.
//

import SwiftUI

struct MainTabView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            ForEach(AppTab.allCases) { tab in
                NavigationStack(path: router.path(for: tab)) {
                    rootView(for: tab)
                        .navigationDestination(for: AppRoute.self) { $0.destination() }
                }
                .tabItem { Label(tab.title, systemImage: tab.icon.symbol) }
                .tag(tab)
            }
        }
        .tint(AppColor.brand)
        .sheet(item: $router.presentedSheet) { sheet in
            sheetView(for: sheet)
        }
    }

    // MARK: Tab roots

    @ViewBuilder
    private func rootView(for tab: AppTab) -> some View {
        switch tab {
        case .planner:  PlannerView()
        case .pantry:   PantryView()
        case .recipes:  RecipeExplorerView()
        case .shopping: ShoppingListView()
        case .stats:    StatisticsView()
        }
    }

    // MARK: Sheets

    @ViewBuilder
    private func sheetView(for sheet: AppSheet) -> some View {
        switch sheet {
        case .settings:
            NavigationStack { SettingsView() }
        case .profile:
            NavigationStack { ProfileView() }
        case .assistant:
            NavigationStack { AssistantView() }
        case .notifications:
            NavigationStack {
                PlaceholderScreen(icon: .notifications, title: "Notifications",
                                  message: "Meal, shopping, expiry and meal-prep reminders.",
                                  phase: "Phase 10")
                    .navigationTitle("Notifications")
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppRouter())
        .environment(AppContainer.preview())
}

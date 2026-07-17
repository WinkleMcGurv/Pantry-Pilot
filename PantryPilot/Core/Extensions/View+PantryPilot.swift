//
//  View+PantryPilot.swift
//  PantryPilot
//
//  General-purpose view helpers.
//

import SwiftUI

extension View {
    /// Standard horizontal screen padding for scrollable content.
    func screenPadding() -> some View {
        self.padding(.horizontal, AppSpacing.screenEdge)
    }

    /// Conditionally applies a transform to the view.
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition { transform(self) } else { self }
    }

    /// Hides the view based on a condition while preserving layout when `remove`
    /// is `false`.
    @ViewBuilder
    func hidden(_ shouldHide: Bool, remove: Bool = false) -> some View {
        if shouldHide {
            if !remove { self.hidden() }
        } else {
            self
        }
    }
}

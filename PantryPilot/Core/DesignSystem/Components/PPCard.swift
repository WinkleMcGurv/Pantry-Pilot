//
//  PPCard.swift
//  PantryPilot
//
//  A rounded surface container used to group content throughout the app.
//

import SwiftUI

/// A padded, rounded surface with an optional elevation.
///
/// ```swift
/// PPCard {
///     Text("Today's plan")
/// }
/// ```
struct PPCard<Content: View>: View {
    var padding: CGFloat = AppSpacing.lg
    var shadow: AppShadow = .soft
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                    .strokeBorder(AppColor.separator, lineWidth: 0.5)
            )
            .appShadow(shadow)
    }
}

extension View {
    /// Wraps the view in the standard card surface treatment.
    func cardStyle(padding: CGFloat = AppSpacing.lg, shadow: AppShadow = .soft) -> some View {
        PPCard(padding: padding, shadow: shadow) { self }
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        PPCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Weekly plan").appFont(.headline)
                Text("21 meals planned").appFont(.subheadline)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        Text("Inline content").cardStyle()
    }
    .padding()
    .background(AppColor.background)
}

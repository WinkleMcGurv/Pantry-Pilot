//
//  PPChip.swift
//  PantryPilot
//
//  A compact pill used for tags, filters and multi-select options.
//

import SwiftUI

/// A selectable pill/tag.
struct PPChip: View {
    let title: String
    var icon: AppIcon?
    var isSelected: Bool = false
    var action: (() -> Void)?

    var body: some View {
        let content = HStack(spacing: AppSpacing.xs) {
            if let icon { icon.image.font(.footnote) }
            Text(title).appFont(.subheadline)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .foregroundStyle(isSelected ? AppColor.onBrand : AppColor.textSecondary)
        .background(isSelected ? AppColor.brand : AppColor.fill)
        .clipShape(Capsule())

        if let action {
            Button(action: action) { content }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
        } else {
            content
        }
    }
}

#Preview {
    HStack {
        PPChip(title: "Vegan", isSelected: true) {}
        PPChip(title: "Under 30 min", icon: .calendar) {}
        PPChip(title: "Budget")
    }
    .padding()
    .background(AppColor.background)
}

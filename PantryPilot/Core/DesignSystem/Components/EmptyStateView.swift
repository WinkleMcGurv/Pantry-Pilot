//
//  EmptyStateView.swift
//  PantryPilot
//
//  A friendly empty-state used when a collection has no content yet.
//

import SwiftUI

/// A centred icon + message with an optional call to action.
struct EmptyStateView: View {
    let icon: AppIcon
    let title: String
    var message: String?
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            icon.image
                .font(.system(size: 44, weight: .regular))
                .foregroundStyle(AppColor.brand)
                .padding(AppSpacing.lg)
                .background(AppColor.brandSoft, in: Circle())

            VStack(spacing: AppSpacing.xs) {
                Text(title)
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                if let message {
                    Text(message)
                        .appFont(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle, let action {
                PPButton(actionTitle, icon: .add, size: .compact, fillWidth: false, action: action)
                    .padding(.top, AppSpacing.xs)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xl)
    }
}

#Preview {
    EmptyStateView(
        icon: .empty,
        title: "Your pantry is empty",
        message: "Add ingredients you already have so PantryPilot can plan around them.",
        actionTitle: "Add ingredient"
    ) {}
    .background(AppColor.background)
}

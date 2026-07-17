//
//  SectionHeader.swift
//  PantryPilot
//
//  A titled section header with an optional trailing action.
//

import SwiftUI

/// A section title with an optional subtitle and trailing button.
struct SectionHeader: View {
    let title: String
    var subtitle: String?
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .appFont(.title3)
                    .foregroundStyle(AppColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
            Spacer(minLength: AppSpacing.md)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .appFont(.subheadline)
                    .foregroundStyle(AppColor.brand)
            }
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.xl) {
        SectionHeader(title: "This week", subtitle: "17–23 July")
        SectionHeader(title: "Pantry", actionTitle: "See all") {}
    }
    .padding()
    .background(AppColor.background)
}

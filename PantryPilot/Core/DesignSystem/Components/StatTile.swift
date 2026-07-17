//
//  StatTile.swift
//  PantryPilot
//
//  A compact metric tile for dashboards (calories, spend, savings, …).
//

import SwiftUI

/// A small card presenting a single metric with a title and optional icon.
struct StatTile: View {
    let title: String
    let value: String
    var caption: String?
    var icon: AppIcon?
    var tint: Color = AppColor.brand

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.xs) {
                if let icon {
                    icon.image
                        .font(.footnote)
                        .foregroundStyle(tint)
                }
                Text(title)
                    .appFont(.footnote)
                    .foregroundStyle(AppColor.textSecondary)
            }
            Text(value)
                .appFont(.title2)
                .foregroundStyle(AppColor.textPrimary)
            if let caption {
                Text(caption)
                    .appFont(.caption)
                    .foregroundStyle(AppColor.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                .strokeBorder(AppColor.separator, lineWidth: 0.5)
        )
    }
}

#Preview {
    HStack(spacing: AppSpacing.md) {
        StatTile(title: "Calories", value: "1,840", caption: "of 2,100", icon: .stats, tint: AppColor.Macro.calories)
        StatTile(title: "Weekly spend", value: "£54", caption: "£16 saved", icon: .budget)
    }
    .padding()
    .background(AppColor.background)
}

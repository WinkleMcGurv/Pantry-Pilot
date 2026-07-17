//
//  PPTextField.swift
//  PantryPilot
//
//  A branded text field with an optional leading icon and label.
//

import SwiftUI

/// A labelled input row backed by a rounded fill.
struct PPTextField: View {
    let title: String
    var icon: AppIcon?
    var placeholder: String = ""
    var keyboard: UIKeyboardType = .default
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .appFont(.subheadline)
                .foregroundStyle(AppColor.textSecondary)

            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    icon.image
                        .foregroundStyle(AppColor.textTertiary)
                        .frame(width: AppSize.iconMedium)
                }
                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .appFont(.body)
                    .foregroundStyle(AppColor.textPrimary)
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(height: AppSize.controlHeight)
            .background(AppColor.fill)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
    }
}

#Preview {
    @Previewable @State var value = ""
    return PPTextField(title: "Name", icon: .profile, placeholder: "Your name", text: $value)
        .padding()
        .background(AppColor.background)
}

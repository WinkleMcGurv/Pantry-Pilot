//
//  PPButton.swift
//  PantryPilot
//
//  The primary button component and its style variants.
//

import SwiftUI

/// Visual variants for ``PPButton``.
enum PPButtonVariant {
    case primary
    case secondary
    case tertiary
    case destructive
}

/// Size options for ``PPButton``.
enum PPButtonSize {
    case regular
    case compact

    var height: CGFloat {
        switch self {
        case .regular: return AppSize.controlHeight
        case .compact: return 40
        }
    }

    var font: AppFont {
        switch self {
        case .regular: return .headline
        case .compact: return .subheadline
        }
    }
}

/// A branded button supporting several variants, an optional leading icon and a
/// loading state.
///
/// ```swift
/// PPButton("Generate week", icon: .regenerate) { plan() }
/// PPButton("Cancel", variant: .tertiary) { dismiss() }
/// ```
struct PPButton: View {
    let title: String
    var icon: AppIcon?
    var variant: PPButtonVariant = .primary
    var size: PPButtonSize = .regular
    var isLoading: Bool = false
    var fillWidth: Bool = true
    let action: () -> Void

    init(
        _ title: String,
        icon: AppIcon? = nil,
        variant: PPButtonVariant = .primary,
        size: PPButtonSize = .regular,
        isLoading: Bool = false,
        fillWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.fillWidth = fillWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(foreground)
                } else if let icon {
                    icon.image
                }
                Text(title)
            }
            .appFont(size.font)
            .frame(maxWidth: fillWidth ? .infinity : nil)
            .frame(height: size.height)
            .padding(.horizontal, AppSpacing.lg)
        }
        .buttonStyle(PPButtonStyle(variant: variant, foreground: foreground))
        .disabled(isLoading)
    }

    private var foreground: Color {
        switch variant {
        case .primary, .destructive: return AppColor.onBrand
        case .secondary, .tertiary:  return AppColor.brand
        }
    }
}

/// Backing `ButtonStyle` that applies the fill, border and press animation.
private struct PPButtonStyle: ButtonStyle {
    let variant: PPButtonVariant
    let foreground: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .background(background(pressed: configuration.isPressed))
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    @ViewBuilder
    private func background(pressed: Bool) -> some View {
        switch variant {
        case .primary:
            AppColor.brand.opacity(pressed ? 0.85 : 1)
        case .destructive:
            AppColor.error.opacity(pressed ? 0.85 : 1)
        case .secondary:
            AppColor.brandSoft.opacity(pressed ? 0.7 : 1)
        case .tertiary:
            Color.clear
        }
    }

    @ViewBuilder
    private var border: some View {
        if variant == .secondary {
            RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                .strokeBorder(AppColor.brand.opacity(0.2), lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        PPButton("Primary action", icon: .add) {}
        PPButton("Secondary", variant: .secondary) {}
        PPButton("Tertiary", variant: .tertiary) {}
        PPButton("Delete", icon: .delete, variant: .destructive) {}
        PPButton("Loading", isLoading: true) {}
        PPButton("Compact", size: .compact, fillWidth: false) {}
    }
    .padding()
    .background(AppColor.background)
}

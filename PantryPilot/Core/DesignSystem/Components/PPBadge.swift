//
//  PPBadge.swift
//  PantryPilot
//
//  A small status badge (e.g. "Expiring", "Vegan", "Locked").
//

import SwiftUI

/// Semantic tone for ``PPBadge``.
enum PPBadgeTone {
    case neutral
    case brand
    case success
    case warning
    case error

    var foreground: Color {
        switch self {
        case .neutral: return AppColor.textSecondary
        case .brand:   return AppColor.brand
        case .success: return AppColor.success
        case .warning: return AppColor.warning
        case .error:   return AppColor.error
        }
    }

    var background: Color { foreground.opacity(0.14) }
}

/// A compact rounded status label.
struct PPBadge: View {
    let text: String
    var icon: AppIcon?
    var tone: PPBadgeTone = .neutral

    var body: some View {
        HStack(spacing: AppSpacing.xxs) {
            if let icon { icon.image.font(.caption2) }
            Text(text).appFont(.captionEmphasised)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xxs)
        .foregroundStyle(tone.foreground)
        .background(tone.background)
        .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        PPBadge(text: "Vegan", tone: .success)
        PPBadge(text: "Expiring", icon: .expiry, tone: .warning)
        PPBadge(text: "Locked", icon: .lock, tone: .brand)
    }
    .padding()
    .background(AppColor.background)
}

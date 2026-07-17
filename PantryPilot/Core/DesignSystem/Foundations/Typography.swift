//
//  Typography.swift
//  PantryPilot
//
//  The type scale. Every font is derived from a Dynamic Type text style so the
//  UI respects the user's preferred content size while keeping a consistent,
//  branded rhythm.
//

import SwiftUI

/// Semantic type ramp for the app.
///
/// Usage: `Text("Title").font(AppFont.title)` or the convenience
/// modifier `Text("Title").appFont(.title)`.
enum AppFont {

    case largeTitle
    case title
    case title2
    case title3
    case headline
    case body
    case bodyEmphasised
    case callout
    case subheadline
    case footnote
    case caption
    case captionEmphasised

    /// The resolved SwiftUI font, scaled for Dynamic Type.
    var font: Font {
        switch self {
        case .largeTitle:        return .system(.largeTitle, design: .rounded, weight: .bold)
        case .title:             return .system(.title, design: .rounded, weight: .bold)
        case .title2:            return .system(.title2, design: .rounded, weight: .semibold)
        case .title3:            return .system(.title3, design: .rounded, weight: .semibold)
        case .headline:          return .system(.headline, design: .rounded, weight: .semibold)
        case .body:              return .system(.body, design: .default, weight: .regular)
        case .bodyEmphasised:    return .system(.body, design: .default, weight: .semibold)
        case .callout:           return .system(.callout, design: .default, weight: .regular)
        case .subheadline:       return .system(.subheadline, design: .default, weight: .medium)
        case .footnote:          return .system(.footnote, design: .default, weight: .regular)
        case .caption:           return .system(.caption, design: .default, weight: .regular)
        case .captionEmphasised: return .system(.caption, design: .rounded, weight: .semibold)
        }
    }
}

extension View {
    /// Applies a semantic `AppFont` to this view.
    func appFont(_ font: AppFont) -> some View {
        self.font(font.font)
    }
}

extension Text {
    /// Applies a semantic `AppFont` to this text.
    func appFont(_ font: AppFont) -> Text {
        self.font(font.font)
    }
}

//
//  ProgressRing.swift
//  PantryPilot
//
//  A circular progress indicator used for calorie/macro targets and budgets.
//

import SwiftUI

/// A circular progress ring with an optional centre label.
struct ProgressRing<Center: View>: View {
    /// Progress in the range 0...1 (values are clamped).
    let progress: Double
    var tint: Color = AppColor.brand
    var lineWidth: CGFloat = 10
    @ViewBuilder var center: () -> Center

    private var clamped: Double { min(max(progress, 0), 1) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColor.fill, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.4), value: clamped)
            center()
        }
    }
}

extension ProgressRing where Center == EmptyView {
    /// A ring with no centre content.
    init(progress: Double, tint: Color = AppColor.brand, lineWidth: CGFloat = 10) {
        self.init(progress: progress, tint: tint, lineWidth: lineWidth) { EmptyView() }
    }
}

#Preview {
    ProgressRing(progress: 0.68) {
        VStack(spacing: 0) {
            Text("68%").appFont(.title3)
            Text("of goal").appFont(.caption)
                .foregroundStyle(AppColor.textSecondary)
        }
    }
    .frame(width: 120, height: 120)
    .padding()
    .background(AppColor.background)
}

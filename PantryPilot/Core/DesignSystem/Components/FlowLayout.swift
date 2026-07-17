//
//  FlowLayout.swift
//  PantryPilot
//
//  A left-aligned wrapping layout for chips and tags. Rows grow to fit their
//  tallest element and wrap when the next element would exceed the available
//  width — the layout equivalent of text wrapping.
//

import SwiftUI

/// Lays out subviews in left-aligned rows, wrapping to a new row when the
/// available width is exhausted.
///
/// ```swift
/// FlowLayout {
///     ForEach(tags) { PPChip(title: $0.name) }
/// }
/// ```
struct FlowLayout: Layout {
    /// Horizontal and vertical gap between elements.
    var spacing: CGFloat = AppSpacing.sm

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = computeRows(subviews: subviews, maxWidth: maxWidth)
        let height = rows.reduce(0) { $0 + $1.height } + spacing * CGFloat(max(0, rows.count - 1))
        let width = proposal.width ?? rows.map(\.width).max() ?? 0
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in computeRows(subviews: subviews, maxWidth: bounds.width) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(
                    at: CGPoint(x: x, y: y + (row.height - size.height) / 2),
                    proposal: .unspecified
                )
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    // MARK: Row computation

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func computeRows(subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows: [Row] = []
        var current = Row()
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            let widthIfAppended = current.indices.isEmpty
                ? size.width
                : current.width + spacing + size.width
            if !current.indices.isEmpty && widthIfAppended > maxWidth {
                rows.append(current)
                current = Row()
            }
            current.width = current.indices.isEmpty ? size.width : current.width + spacing + size.width
            current.indices.append(index)
            current.height = max(current.height, size.height)
        }
        if !current.indices.isEmpty { rows.append(current) }
        return rows
    }
}

#Preview {
    FlowLayout {
        ForEach(Cuisine.allCases) { cuisine in
            PPChip(title: cuisine.title, isSelected: cuisine == .italian) {}
        }
    }
    .padding()
    .background(AppColor.background)
}

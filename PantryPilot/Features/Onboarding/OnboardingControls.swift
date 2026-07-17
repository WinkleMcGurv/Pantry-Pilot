//
//  OnboardingControls.swift
//  PantryPilot
//
//  Small controls shared by the onboarding step views: the step scaffold,
//  selectable option cards, a stepper row, wrapping chip grids and a free-text
//  tag editor. They compose the design system rather than extending it —
//  nothing here is needed outside onboarding yet.
//

import SwiftUI

// MARK: - Step scaffold

/// Standard chrome for a questionnaire step: scrolling content under a title
/// and subtitle, with consistent insets.
struct OnboardingStepScaffold<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(title)
                        .appFont(.title)
                        .foregroundStyle(AppColor.textPrimary)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .appFont(.body)
                            .foregroundStyle(AppColor.textSecondary)
                    }
                }
                .accessibilityElement(children: .combine)

                content()
            }
            .screenPadding()
            .padding(.vertical, AppSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - Option card

/// A full-width selectable card for single-choice questions.
struct OnboardingOptionCard: View {
    let title: String
    var subtitle: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(title)
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .appFont(.footnote)
                            .foregroundStyle(AppColor.textSecondary)
                    }
                }
                .multilineTextAlignment(.leading)

                Spacer(minLength: AppSpacing.sm)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppColor.brand : AppColor.textTertiary)
                    .accessibilityHidden(true)
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? AppColor.brandSoft : AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                    .strokeBorder(isSelected ? AppColor.brand : AppColor.separator, lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Stepper row

/// A labelled value with minus/plus controls, e.g. household size.
struct OnboardingStepperRow: View {
    let title: String
    var subtitle: String?
    @Binding var value: Int
    let range: ClosedRange<Int>
    /// Formats the value for display, e.g. `"3 meals"`.
    var display: (Int) -> String = { "\($0)" }
    var onChange: (() -> Void)?

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                }
            }

            Spacer(minLength: AppSpacing.sm)

            HStack(spacing: AppSpacing.md) {
                stepButton(symbol: "minus", enabled: value > range.lowerBound) { adjust(by: -1) }
                Text(display(value))
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(minWidth: 64)
                    .contentTransition(.numericText())
                stepButton(symbol: "plus", enabled: value < range.upperBound) { adjust(by: 1) }
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                .strokeBorder(AppColor.separator, lineWidth: 0.5)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(subtitle.map { "\(title). \($0)" } ?? title)
        .accessibilityValue(display(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: adjust(by: 1)
            case .decrement: adjust(by: -1)
            @unknown default: break
            }
        }
    }

    private func adjust(by delta: Int) {
        let newValue = value + delta
        guard range.contains(newValue) else { return }
        withAnimation(.snappy(duration: 0.2)) { value = newValue }
        onChange?()
    }

    private func stepButton(symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(enabled ? AppColor.brand : AppColor.textTertiary)
                .frame(width: 36, height: 36)
                .background(AppColor.fill, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}

// MARK: - Chip grid

/// A wrapping grid of selectable chips for multi-choice (or exclusive-choice)
/// enum questions.
struct OnboardingChipGrid<Option: Hashable & Identifiable>: View {
    let options: [Option]
    let title: (Option) -> String
    let isSelected: (Option) -> Bool
    let onToggle: (Option) -> Void

    var body: some View {
        FlowLayout {
            ForEach(options) { option in
                PPChip(title: title(option), isSelected: isSelected(option)) {
                    onToggle(option)
                }
            }
        }
    }
}

// MARK: - Tag editor

/// Free-text entry that accumulates removable tags (favourite foods, disliked
/// foods, supermarkets).
struct OnboardingTagEditor: View {
    let title: String
    let placeholder: String
    @Binding var tags: [String]
    /// Called with the raw draft; returns `true` when it was accepted.
    let onAdd: (String) -> Bool
    let onRemove: (String) -> Void

    @State private var draft = ""

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                PPTextField(title: title, placeholder: placeholder, text: $draft)
                    .onSubmit(addDraft)
                    .submitLabel(.done)

                Button(action: addDraft) {
                    AppIcon.add.image
                        .font(.body.weight(.semibold))
                        .foregroundStyle(canAdd ? AppColor.onBrand : AppColor.textTertiary)
                        .frame(width: AppSize.controlHeight, height: AppSize.controlHeight)
                        .background(
                            canAdd ? AppColor.brand : AppColor.fill,
                            in: RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                .disabled(!canAdd)
                .accessibilityLabel("Add \(draft.isEmpty ? title.lowercased() : draft)")
            }

            if !tags.isEmpty {
                FlowLayout {
                    ForEach(tags, id: \.self) { tag in
                        removableTag(tag)
                    }
                }
                .animation(.snappy(duration: 0.25), value: tags)
            }
        }
    }

    private var canAdd: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func addDraft() {
        guard onAdd(draft) else { return }
        draft = ""
    }

    private func removableTag(_ tag: String) -> some View {
        Button {
            onRemove(tag)
        } label: {
            HStack(spacing: AppSpacing.xs) {
                Text(tag).appFont(.subheadline)
                AppIcon.close.image
                    .font(.caption.weight(.semibold))
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .foregroundStyle(AppColor.textPrimary)
            .background(AppColor.fill)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Remove \(tag)")
    }
}

// MARK: - Previews

#Preview("Controls") {
    @Previewable @State var count = 3
    @Previewable @State var tags = ["Chicken", "Halloumi"]
    @Previewable @State var selected: Set<Cuisine> = [.italian]

    return ScrollView {
        VStack(spacing: AppSpacing.lg) {
            OnboardingOptionCard(title: "Moderately active", subtitle: "Exercise 3–5 days a week", isSelected: true) {}
            OnboardingOptionCard(title: "Sedentary", subtitle: "Little or no exercise", isSelected: false) {}
            OnboardingStepperRow(title: "Meals per day", value: $count, range: 2...6, display: { "\($0)" })
            OnboardingChipGrid(
                options: Cuisine.allCases,
                title: \.title,
                isSelected: { selected.contains($0) },
                onToggle: { selected.formSymmetricDifference([$0]) }
            )
            OnboardingTagEditor(
                title: "Favourite foods",
                placeholder: "e.g. salmon",
                tags: $tags,
                onAdd: { tags.append($0); return true },
                onRemove: { tag in tags.removeAll { $0 == tag } }
            )
        }
        .padding()
    }
    .background(AppColor.background)
}

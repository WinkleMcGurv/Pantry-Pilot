//
//  OnboardingSteps.swift
//  PantryPilot
//
//  The individual pages of the onboarding questionnaire. Each step renders
//  inside `OnboardingStepScaffold` and binds directly to the shared
//  `OnboardingViewModel`.
//

import SwiftUI

// MARK: - Welcome

struct OnboardingWelcomeStep: View {
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()

            VStack(spacing: AppSpacing.lg) {
                AppIcon.recipes.image
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(AppColor.onBrand)
                    .frame(width: 112, height: 112)
                    .background(AppColor.brand, in: RoundedRectangle(cornerRadius: AppRadius.xl, style: .continuous))
                    .accessibilityHidden(true)

                VStack(spacing: AppSpacing.sm) {
                    Text("Welcome to PantryPilot")
                        .appFont(.largeTitle)
                        .foregroundStyle(AppColor.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Effortless weekly meal plans that use what you already have, hit your goals and save money.")
                        .appFont(.body)
                        .foregroundStyle(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                highlight(icon: .planner, title: "Plans built around you", detail: "Goals, tastes, allergies and schedule all respected.")
                highlight(icon: .pantry, title: "Waste less", detail: "The planner reaches for your pantry first.")
                highlight(icon: .budget, title: "Spend smarter", detail: "Every week is optimised for your budget.")
            }
            .padding(.horizontal, AppSpacing.sm)

            Spacer()

            Text("A couple of minutes of questions — every answer can be changed later.")
                .appFont(.footnote)
                .foregroundStyle(AppColor.textTertiary)
                .multilineTextAlignment(.center)
        }
        .screenPadding()
        .padding(.vertical, AppSpacing.xl)
    }

    private func highlight(icon: AppIcon, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            icon.image
                .font(.body.weight(.semibold))
                .foregroundStyle(AppColor.brand)
                .frame(width: AppSize.iconLarge, height: AppSize.iconLarge)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                Text(detail)
                    .appFont(.footnote)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - About you

struct OnboardingAboutStep: View {
    @Bindable var model: OnboardingViewModel

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(spacing: AppSpacing.lg) {
                PPTextField(title: "Name", icon: .profile, placeholder: "Your name", text: $model.name)
                    .textContentType(.givenName)

                PPTextField(title: "Age (optional)", placeholder: "e.g. 32", keyboard: .numberPad, text: $model.ageText)

                OnboardingStepperRow(
                    title: "Household size",
                    subtitle: "How many people you usually cook for",
                    value: $model.householdSize,
                    range: OnboardingViewModel.Limits.householdSize,
                    display: { $0 == 1 ? "Just me" : "\($0) people" }
                )
            }
        }
    }
}

// MARK: - Body & activity

struct OnboardingBodyStep: View {
    @Bindable var model: OnboardingViewModel

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                HStack(alignment: .top, spacing: AppSpacing.md) {
                    PPTextField(title: "Height (cm)", placeholder: "e.g. 178", keyboard: .decimalPad, text: $model.heightText)
                    PPTextField(title: "Weight (kg)", placeholder: "e.g. 74.5", keyboard: .decimalPad, text: $model.weightText)
                }

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Activity level", subtitle: "Your typical week")
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(ActivityLevel.allCases) { level in
                            OnboardingOptionCard(
                                title: level.title,
                                subtitle: level.detail,
                                isSelected: model.activityLevel == level
                            ) {
                                model.activityLevel = level
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Goals & targets

struct OnboardingGoalsStep: View {
    @Bindable var model: OnboardingViewModel
    @Environment(AppContainer.self) private var container

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(FitnessGoal.allCases) { goal in
                        OnboardingOptionCard(
                            title: goal.title,
                            subtitle: goal.detail,
                            isSelected: model.goal == goal
                        ) {
                            model.goal = goal
                        }
                    }
                }

                if let suggestion = model.suggestedTargets {
                    suggestionCard(suggestion)
                }

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Daily targets", subtitle: "Optional — leave blank to decide later")
                    HStack(alignment: .top, spacing: AppSpacing.md) {
                        PPTextField(title: "Calories (kcal)", placeholder: "e.g. 2200", keyboard: .numberPad, text: $model.calorieText)
                        PPTextField(title: "Protein (g)", placeholder: "e.g. 130", keyboard: .numberPad, text: $model.proteinText)
                    }
                }
            }
        }
    }

    private func suggestionCard(_ suggestion: OnboardingViewModel.SuggestedTargets) -> some View {
        PPCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack(spacing: AppSpacing.sm) {
                    AppIcon.assistant.image
                        .foregroundStyle(AppColor.accent)
                        .accessibilityHidden(true)
                    Text("Suggested for you")
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                }

                Text("Based on your body metrics, activity and goal: **\(AppFormat.calories(suggestion.calories))** and **\(AppFormat.grams(suggestion.proteinGrams)) protein** a day. An estimate, not medical advice.")
                    .appFont(.footnote)
                    .foregroundStyle(AppColor.textSecondary)

                PPButton("Use these targets", icon: .checkmark, variant: .secondary, size: .compact) {
                    container.haptics.play(.selection)
                    withAnimation(.snappy(duration: 0.25)) {
                        model.applySuggestedTargets()
                    }
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

// MARK: - Cooking style

struct OnboardingCookingStep: View {
    @Bindable var model: OnboardingViewModel
    @Environment(AppContainer.self) private var container

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Cooking confidence")
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(CookingAbility.allCases) { ability in
                            OnboardingOptionCard(
                                title: ability.title,
                                subtitle: ability.detail,
                                isSelected: model.cookingAbility == ability
                            ) {
                                model.cookingAbility = ability
                            }
                        }
                    }
                }

                OnboardingStepperRow(
                    title: "Meals per day",
                    subtitle: "Snacks are planned separately",
                    value: $model.mealsPerDay,
                    range: OnboardingViewModel.Limits.mealsPerDay
                )

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Max cooking time", subtitle: "Per meal, on a normal day")
                    OnboardingChipGrid(
                        options: OnboardingViewModel.Limits.cookingTimeOptions.map(TimeOption.init),
                        title: { AppFormat.minutes($0.minutes) },
                        isSelected: { model.maxCookingTimeMinutes == $0.minutes },
                        onToggle: { option in
                            container.haptics.play(.selection)
                            model.maxCookingTimeMinutes = option.minutes
                        }
                    )
                }
            }
        }
    }

    private struct TimeOption: Hashable, Identifiable {
        let minutes: Int
        var id: Int { minutes }
    }
}

// MARK: - Tastes

struct OnboardingTastesStep: View {
    @Bindable var model: OnboardingViewModel
    @Environment(AppContainer.self) private var container

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Favourite cuisines", subtitle: "Pick as many as you like")
                    OnboardingChipGrid(
                        options: Cuisine.allCases,
                        title: \.title,
                        isSelected: { model.favouriteCuisines.contains($0) },
                        onToggle: { cuisine in
                            container.haptics.play(.selection)
                            model.toggle(cuisine)
                        }
                    )
                }

                OnboardingTagEditor(
                    title: "Favourite foods",
                    placeholder: "e.g. salmon, halloumi",
                    tags: $model.favouriteFoods,
                    onAdd: { model.addTag($0, to: \.favouriteFoods) },
                    onRemove: { model.removeTag($0, from: \.favouriteFoods) }
                )

                OnboardingTagEditor(
                    title: "Foods to avoid",
                    placeholder: "e.g. mushrooms",
                    tags: $model.dislikedFoods,
                    onAdd: { model.addTag($0, to: \.dislikedFoods) },
                    onRemove: { model.removeTag($0, from: \.dislikedFoods) }
                )
            }
        }
    }
}

// MARK: - Restrictions

struct OnboardingRestrictionsStep: View {
    @Bindable var model: OnboardingViewModel
    @Environment(AppContainer.self) private var container

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Dietary preference")
                    OnboardingChipGrid(
                        options: DietaryPreference.allCases,
                        title: \.title,
                        isSelected: { model.dietaryPreferences.contains($0) },
                        onToggle: { preference in
                            container.haptics.play(.selection)
                            model.toggle(preference)
                        }
                    )
                }

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Allergies", subtitle: "Recipes containing these are always excluded")
                    OnboardingChipGrid(
                        options: Allergen.allCases,
                        title: \.title,
                        isSelected: { model.allergies.contains($0) },
                        onToggle: { allergen in
                            container.haptics.play(.selection)
                            model.toggle(allergen)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Budget & shopping

struct OnboardingBudgetStep: View {
    @Bindable var model: OnboardingViewModel
    @Environment(AppContainer.self) private var container

    /// Common UK supermarkets offered as one-tap options.
    private static let suggestedSupermarkets = [
        "Tesco", "Sainsbury's", "Asda", "Aldi", "Lidl",
        "Morrisons", "Waitrose", "M&S", "Co-op", "Iceland",
    ]

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                PPTextField(
                    title: "Weekly grocery budget (£, optional)",
                    icon: .budget,
                    placeholder: "e.g. 65",
                    keyboard: .decimalPad,
                    text: $model.budgetText
                )

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    SectionHeader(title: "Where do you shop?", subtitle: "Used for cost estimates")
                    OnboardingChipGrid(
                        options: Self.suggestedSupermarkets.map(Supermarket.init),
                        title: \.name,
                        isSelected: { model.preferredSupermarkets.contains($0.name) },
                        onToggle: { shop in
                            container.haptics.play(.selection)
                            if model.preferredSupermarkets.contains(shop.name) {
                                model.removeTag(shop.name, from: \.preferredSupermarkets)
                            } else {
                                model.addTag(shop.name, to: \.preferredSupermarkets)
                            }
                        }
                    )

                    OnboardingTagEditor(
                        title: "Somewhere else",
                        placeholder: "e.g. local market",
                        tags: otherSupermarkets,
                        onAdd: { model.addTag($0, to: \.preferredSupermarkets) },
                        onRemove: { model.removeTag($0, from: \.preferredSupermarkets) }
                    )
                }
            }
        }
    }

    /// Custom entries only — the suggested chains render as chips above.
    private var otherSupermarkets: Binding<[String]> {
        Binding(
            get: { model.preferredSupermarkets.filter { !Self.suggestedSupermarkets.contains($0) } },
            set: { _ in }
        )
    }

    private struct Supermarket: Hashable, Identifiable {
        let name: String
        var id: String { name }
    }
}

// MARK: - Summary

struct OnboardingSummaryStep: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingStepScaffold(title: model.step.title, subtitle: model.step.subtitle) {
            VStack(spacing: AppSpacing.lg) {
                summaryCard(title: "You") {
                    row("Name", model.trimmedName)
                    row("Age", model.age.map(String.init))
                    row("Household", model.householdSize == 1 ? "Just me" : "\(model.householdSize) people")
                    row("Activity", model.activityLevel.title)
                }

                summaryCard(title: "Goals") {
                    row("Goal", model.goal.title)
                    row("Calories", model.calorieTarget.map(AppFormat.calories))
                    row("Protein", model.proteinTarget.map { "\(AppFormat.grams($0)) / day" })
                }

                summaryCard(title: "Cooking") {
                    row("Confidence", model.cookingAbility.title)
                    row("Meals per day", "\(model.mealsPerDay)")
                    row("Max time", AppFormat.minutes(model.maxCookingTimeMinutes))
                }

                summaryCard(title: "Tastes & restrictions") {
                    row("Cuisines", list(model.favouriteCuisines.map(\.title)))
                    row("Favourites", list(model.favouriteFoods))
                    row("Avoiding", list(model.dislikedFoods))
                    row("Diet", list(model.dietaryPreferences.filter { $0 != .none }.map(\.title)))
                    row("Allergies", list(model.allergies.map(\.title)))
                }

                summaryCard(title: "Shopping") {
                    row("Weekly budget", model.weeklyBudget.map(AppFormat.currency))
                    row("Supermarkets", list(model.preferredSupermarkets))
                }
            }
        }
    }

    private func list(_ items: [String]) -> String? {
        items.isEmpty ? nil : items.joined(separator: ", ")
    }

    private func summaryCard(title: String, @ViewBuilder rows: () -> some View) -> some View {
        let rowsContent = rows()
        return PPCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text(title)
                    .appFont(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                rowsContent
            }
        }
    }

    @ViewBuilder
    private func row(_ label: String, _ value: String?) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppSpacing.md) {
            Text(label)
                .appFont(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
                .frame(width: 110, alignment: .leading)
            Text(value ?? "Not set")
                .appFont(.callout)
                .foregroundStyle(value == nil ? AppColor.textTertiary : AppColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Steps") {
    OnboardingView(onFinished: {})
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.makeContainer(inMemory: true))
}

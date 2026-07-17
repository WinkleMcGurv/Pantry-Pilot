//
//  OnboardingViewModel.swift
//  PantryPilot
//
//  State, validation and persistence for the multi-step onboarding
//  questionnaire. Numeric answers are held as raw text (mirroring the text
//  fields) and parsed on demand so validation can distinguish "empty" from
//  "invalid" without fighting the keyboard.
//

import Foundation
import SwiftData
import Observation

@MainActor
@Observable
final class OnboardingViewModel {

    // MARK: Steps

    /// The questionnaire pages, in order. `welcome` sits outside the numbered
    /// progress (it is an intro, not a question).
    enum Step: Int, CaseIterable {
        case welcome, about, body, goals, cooking, tastes, restrictions, budget, summary

        var title: String {
            switch self {
            case .welcome:      return "Welcome"
            case .about:        return "About you"
            case .body:         return "Body & activity"
            case .goals:        return "Your goals"
            case .cooking:      return "Cooking style"
            case .tastes:       return "Tastes"
            case .restrictions: return "Restrictions"
            case .budget:       return "Budget & shopping"
            case .summary:      return "All set"
            }
        }

        var subtitle: String {
            switch self {
            case .welcome:      return ""
            case .about:        return "A few basics so PantryPilot can plan for your household."
            case .body:         return "Used only to estimate your nutrition targets. Optional."
            case .goals:        return "Set daily targets — or let PantryPilot suggest them."
            case .cooking:      return "Plans will match your confidence and available time."
            case .tastes:       return "Tell the planner what you love (and what to avoid)."
            case .restrictions: return "Diets and allergies are always respected by every plan."
            case .budget:       return "PantryPilot optimises each week around your budget."
            case .summary:      return "Here's what PantryPilot will plan around. You can change any of it later from your profile."
            }
        }
    }

    private(set) var step: Step = .welcome
    /// `true` when the last transition moved forward (drives slide direction).
    private(set) var isMovingForward = true

    /// Number of questionnaire steps shown in the progress indicator.
    var questionStepCount: Int { Step.allCases.count - 1 }
    /// 1-based position of the current step within the questionnaire.
    var questionStepIndex: Int { max(1, step.rawValue) }
    /// Progress through the questionnaire in `0...1`.
    var progress: Double { Double(step.rawValue) / Double(Step.summary.rawValue) }

    // MARK: Answers — about you

    var name = ""
    var ageText = ""
    var householdSize = 1

    // MARK: Answers — body & activity

    var heightText = ""
    var weightText = ""
    var activityLevel: ActivityLevel = .moderate

    // MARK: Answers — goals & targets

    var goal: FitnessGoal = .maintain
    var calorieText = ""
    var proteinText = ""

    // MARK: Answers — cooking

    var cookingAbility: CookingAbility = .comfortable
    var mealsPerDay = 3
    var maxCookingTimeMinutes = 45

    // MARK: Answers — tastes

    var favouriteCuisines: Set<Cuisine> = []
    var favouriteFoods: [String] = []
    var dislikedFoods: [String] = []

    // MARK: Answers — restrictions

    var dietaryPreferences: Set<DietaryPreference> = []
    var allergies: Set<Allergen> = []

    // MARK: Answers — budget & shopping

    var budgetText = ""
    var preferredSupermarkets: [String] = []

    // MARK: Parsed values

    var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }
    var age: Int? { Int(ageText.trimmingCharacters(in: .whitespaces)) }
    var heightCm: Double? { Self.parseDecimal(heightText) }
    var weightKg: Double? { Self.parseDecimal(weightText) }
    var calorieTarget: Int? { Int(calorieText.trimmingCharacters(in: .whitespaces)) }
    var proteinTarget: Double? { Self.parseDecimal(proteinText) }
    var weeklyBudget: Double? { Self.parseDecimal(budgetText) }

    /// Parses user-entered decimals, tolerating a comma decimal separator.
    private static func parseDecimal(_ text: String) -> Double? {
        Double(text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "."))
    }

    // MARK: Valid ranges

    enum Limits {
        static let age = 13...110
        static let heightCm = 100.0...250.0
        static let weightKg = 30.0...300.0
        static let calories = 800...8000
        static let proteinGrams = 10.0...400.0
        static let budget = 0.0...2000.0
        static let mealsPerDay = 1...6
        static let householdSize = 1...10
        static let cookingTimeOptions = [15, 30, 45, 60, 90]
    }

    // MARK: Validation

    /// Whether the given step's answers allow moving on.
    func canAdvance(from step: Step) -> Bool {
        validationMessage(for: step) == nil
    }

    /// A human-readable reason the current step can't be advanced, or `nil`
    /// when everything on the step is valid. Optional fields only fail when
    /// they contain unparseable or out-of-range input.
    func validationMessage(for step: Step) -> String? {
        switch step {
        case .about:
            if trimmedName.isEmpty { return "Enter your name to continue." }
            if !ageText.isEmpty, age.map(Limits.age.contains) != true {
                return "Age should be between \(Limits.age.lowerBound) and \(Limits.age.upperBound), or left blank."
            }
        case .body:
            if !heightText.isEmpty, heightCm.map(Limits.heightCm.contains) != true {
                return "Height should be \(Int(Limits.heightCm.lowerBound))–\(Int(Limits.heightCm.upperBound)) cm, or left blank."
            }
            if !weightText.isEmpty, weightKg.map(Limits.weightKg.contains) != true {
                return "Weight should be \(Int(Limits.weightKg.lowerBound))–\(Int(Limits.weightKg.upperBound)) kg, or left blank."
            }
        case .goals:
            if !calorieText.isEmpty, calorieTarget.map(Limits.calories.contains) != true {
                return "Daily calories should be \(Limits.calories.lowerBound)–\(Limits.calories.upperBound) kcal, or left blank."
            }
            if !proteinText.isEmpty, proteinTarget.map(Limits.proteinGrams.contains) != true {
                return "Protein should be \(Int(Limits.proteinGrams.lowerBound))–\(Int(Limits.proteinGrams.upperBound)) g, or left blank."
            }
        case .budget:
            if !budgetText.isEmpty, weeklyBudget.map(Limits.budget.contains) != true {
                return "Weekly budget should be a number up to \(Int(Limits.budget.upperBound)), or left blank."
            }
        case .welcome, .cooking, .tastes, .restrictions, .summary:
            break
        }
        return nil
    }

    // MARK: Navigation

    func advance() {
        guard canAdvance(from: step), let next = Step(rawValue: step.rawValue + 1) else { return }
        isMovingForward = true
        step = next
    }

    func goBack() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        isMovingForward = false
        step = previous
    }

    // MARK: Suggested nutrition targets

    struct SuggestedTargets: Equatable {
        let calories: Int
        let proteinGrams: Double
    }

    /// Estimated daily targets derived from body metrics, activity and goal.
    /// Uses the Mifflin–St Jeor equation with a sex-neutral midpoint constant,
    /// so it is a starting estimate rather than a prescription. `nil` until
    /// age, height and weight are all provided and valid.
    var suggestedTargets: SuggestedTargets? {
        guard
            let age, Limits.age.contains(age),
            let heightCm, Limits.heightCm.contains(heightCm),
            let weightKg, Limits.weightKg.contains(weightKg)
        else { return nil }

        let bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 78
        let maintenance = bmr * activityLevel.tdeeMultiplier
        let target = max(1_200, maintenance + goal.calorieAdjustment)
        let calories = Int((target / 25).rounded() * 25)
        let protein = (weightKg * goal.proteinGramsPerKg).rounded()
        return SuggestedTargets(calories: calories, proteinGrams: protein)
    }

    /// Copies the suggested targets into the editable target fields.
    func applySuggestedTargets() {
        guard let suggestion = suggestedTargets else { return }
        calorieText = String(suggestion.calories)
        proteinText = String(Int(suggestion.proteinGrams))
    }

    // MARK: Multi-select handling

    func toggle(_ cuisine: Cuisine) {
        favouriteCuisines.formSymmetricDifference([cuisine])
    }

    func toggle(_ allergen: Allergen) {
        allergies.formSymmetricDifference([allergen])
    }

    /// Selecting "No preference" clears the others, and vice versa.
    func toggle(_ preference: DietaryPreference) {
        if preference == .none {
            dietaryPreferences = dietaryPreferences.contains(.none) ? [] : [.none]
        } else {
            dietaryPreferences.remove(.none)
            dietaryPreferences.formSymmetricDifference([preference])
        }
    }

    // MARK: Free-text tags

    /// Adds a trimmed, de-duplicated (case-insensitively) tag to a list.
    /// Returns `true` when the tag was added.
    @discardableResult
    func addTag(_ raw: String, to list: ReferenceWritableKeyPath<OnboardingViewModel, [String]>) -> Bool {
        let tag = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !tag.isEmpty, tag.count <= 40 else { return false }
        var target = self[keyPath: list]
        guard !target.contains(where: { $0.caseInsensitiveCompare(tag) == .orderedSame }) else { return false }
        target.append(tag)
        self[keyPath: list] = target
        return true
    }

    func removeTag(_ tag: String, from list: ReferenceWritableKeyPath<OnboardingViewModel, [String]>) {
        self[keyPath: list] = self[keyPath: list].filter { $0 != tag }
    }

    // MARK: Persistence

    /// Writes every answer to the single `UserProfile` (creating it if needed),
    /// marks onboarding complete and saves.
    func complete(in context: ModelContext) throws {
        let profile: UserProfile
        if let existing = try context.fetch(FetchDescriptor<UserProfile>()).first {
            profile = existing
        } else {
            profile = UserProfile()
            context.insert(profile)
        }

        profile.name = trimmedName
        profile.age = age
        profile.heightCm = heightCm
        profile.weightKg = weightKg
        profile.activityLevel = activityLevel
        profile.goal = goal
        profile.dailyCalorieTarget = calorieTarget
        profile.proteinTargetGrams = proteinTarget
        profile.weeklyBudget = weeklyBudget
        profile.mealsPerDay = mealsPerDay
        profile.cookingAbility = cookingAbility
        profile.maxCookingTimeMinutes = maxCookingTimeMinutes
        profile.householdSize = householdSize
        profile.favouriteCuisines = Cuisine.allCases.filter(favouriteCuisines.contains)
        profile.favouriteFoods = favouriteFoods
        profile.dislikedFoods = dislikedFoods
        profile.allergies = Allergen.allCases.filter(allergies.contains)
        profile.dietaryPreferences = DietaryPreference.allCases.filter { $0 != .none && dietaryPreferences.contains($0) }
        profile.preferredSupermarkets = preferredSupermarkets
        profile.onboardingCompleted = true

        try context.save()
    }
}

// MARK: - Estimation coefficients

extension ActivityLevel {
    /// Standard TDEE multiplier applied to basal metabolic rate.
    var tdeeMultiplier: Double {
        switch self {
        case .sedentary:  return 1.2
        case .light:      return 1.375
        case .moderate:   return 1.55
        case .active:     return 1.725
        case .veryActive: return 1.9
        }
    }

    /// Short description shown on the selection card.
    var detail: String {
        switch self {
        case .sedentary:  return "Little or no exercise"
        case .light:      return "Exercise 1–3 days a week"
        case .moderate:   return "Exercise 3–5 days a week"
        case .active:     return "Exercise 6–7 days a week"
        case .veryActive: return "Hard training or a physical job"
        }
    }
}

extension FitnessGoal {
    /// Daily calorie adjustment applied to maintenance for this goal.
    var calorieAdjustment: Double {
        switch self {
        case .lose:          return -400
        case .maintain:      return 0
        case .gain:          return 300
        case .recomposition: return 0
        }
    }

    /// Suggested daily protein in grams per kilogram of body weight.
    var proteinGramsPerKg: Double {
        switch self {
        case .lose:          return 1.8
        case .maintain:      return 1.4
        case .gain:          return 1.8
        case .recomposition: return 2.0
        }
    }

    /// Short description shown on the selection card.
    var detail: String {
        switch self {
        case .lose:          return "A gentle calorie deficit"
        case .maintain:      return "Balanced plans at maintenance"
        case .gain:          return "A protein-focused surplus"
        case .recomposition: return "High protein at maintenance"
        }
    }
}

extension CookingAbility {
    /// Short description shown on the selection card.
    var detail: String {
        switch self {
        case .beginner:    return "Simple recipes, few steps"
        case .comfortable: return "Happy with most recipes"
        case .advanced:    return "Bring on the challenge"
        }
    }
}

//
//  OnboardingView.swift
//  PantryPilot
//
//  The multi-step onboarding questionnaire. Hosts the step views, the animated
//  progress header and the continue/back controls, and persists the completed
//  answers to the single `UserProfile`.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppContainer.self) private var container
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Called once a profile exists and onboarding is marked complete.
    let onFinished: () -> Void

    @State private var model = OnboardingViewModel()
    @State private var saveFailed = false

    var body: some View {
        VStack(spacing: 0) {
            if model.step != .welcome {
                header
                    .transition(.opacity)
            }

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            footer
        }
        .background(AppColor.background)
        .animation(stepAnimation, value: model.step)
        .alert("Couldn't save your profile", isPresented: $saveFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong while saving. Please try again.")
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(spacing: AppSpacing.md) {
            Button {
                container.haptics.play(.light)
                model.goBack()
            } label: {
                AppIcon.chevronLeft.image
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    .background(AppColor.fill, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back")

            progressBar

            // Mirrors the back button so the bar stays centred.
            Color.clear
                .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                .accessibilityHidden(true)
        }
        .screenPadding()
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.xs)
    }

    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColor.fill)
                Capsule()
                    .fill(AppColor.brand)
                    .frame(width: max(8, proxy.size.width * model.progress))
            }
        }
        .frame(height: 6)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("Step \(model.questionStepIndex) of \(model.questionStepCount)")
    }

    // MARK: Step content

    @ViewBuilder
    private var content: some View {
        Group {
            switch model.step {
            case .welcome:      OnboardingWelcomeStep()
            case .about:        OnboardingAboutStep(model: model)
            case .body:         OnboardingBodyStep(model: model)
            case .goals:        OnboardingGoalsStep(model: model)
            case .cooking:      OnboardingCookingStep(model: model)
            case .tastes:       OnboardingTastesStep(model: model)
            case .restrictions: OnboardingRestrictionsStep(model: model)
            case .budget:       OnboardingBudgetStep(model: model)
            case .summary:      OnboardingSummaryStep(model: model)
            }
        }
        .id(model.step)
        .transition(stepTransition)
    }

    /// Slides forward or backward with a fade; plain fade under Reduce Motion.
    private var stepTransition: AnyTransition {
        guard !reduceMotion else { return .opacity }
        let enter: Edge = model.isMovingForward ? .trailing : .leading
        let exit: Edge = model.isMovingForward ? .leading : .trailing
        return .asymmetric(
            insertion: .move(edge: enter).combined(with: .opacity),
            removal: .move(edge: exit).combined(with: .opacity)
        )
    }

    private var stepAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .snappy(duration: 0.35)
    }

    // MARK: Footer

    private var footer: some View {
        VStack(spacing: AppSpacing.sm) {
            if let message = model.validationMessage(for: model.step) {
                Text(message)
                    .appFont(.footnote)
                    .foregroundStyle(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                    .accessibilityAddTraits(.updatesFrequently)
            }

            PPButton(
                primaryButtonTitle,
                icon: model.step == .summary ? .checkmark : nil
            ) {
                primaryAction()
            }
            .disabled(!model.canAdvance(from: model.step))
            .opacity(model.canAdvance(from: model.step) ? 1 : 0.5)
        }
        .screenPadding()
        .padding(.vertical, AppSpacing.lg)
        .background(.ultraThinMaterial)
        .animation(.easeOut(duration: 0.2), value: model.validationMessage(for: model.step))
    }

    private var primaryButtonTitle: String {
        switch model.step {
        case .welcome: return "Get started"
        case .summary: return "Finish setup"
        default:       return "Continue"
        }
    }

    private func primaryAction() {
        if model.step == .summary {
            finish()
        } else {
            container.haptics.play(.light)
            model.advance()
        }
    }

    private func finish() {
        do {
            try model.complete(in: context)
            container.haptics.play(.success)
            onFinished()
        } catch {
            AppLogger.app.error("Failed to save onboarding profile: \(error)")
            container.haptics.play(.error)
            saveFailed = true
        }
    }
}

#Preview("Onboarding") {
    OnboardingView(onFinished: {})
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.makeContainer(inMemory: true))
}

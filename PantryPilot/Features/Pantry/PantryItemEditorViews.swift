//
//  PantryItemEditorViews.swift
//  PantryPilot
//
//  The two presentations of the pantry item form: a sheet for adding a new
//  item and a pushed detail screen for editing an existing one. Both wrap
//  `PantryItemEditorContent`, which owns the scroll layout and the bottom CTA
//  (hidden while the keyboard is up, per the app's form conventions).
//

import SwiftUI
import SwiftData
import UIKit

// MARK: - Shared editor chrome

/// Scrolling form + bottom call-to-action. The CTA hides while typing so it
/// never floats above the keyboard; the keyboard accessory handles Done.
struct PantryItemEditorContent: View {
    @Binding var draft: PantryItemDraft
    let ctaTitle: String
    let onCommit: () -> Void

    @State private var keyboardVisible = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                PantryItemFormFields(draft: $draft)
                    .screenPadding()
                    .padding(.vertical, AppSpacing.xl)
            }
            .scrollDismissesKeyboard(.interactively)

            if !keyboardVisible {
                footer
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(AppColor.background)
        .animation(.easeOut(duration: 0.2), value: keyboardVisible)
        .animation(.easeOut(duration: 0.2), value: draft.validationMessage)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            keyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardVisible = false
        }
    }

    private var footer: some View {
        VStack(spacing: AppSpacing.sm) {
            if let message = draft.validationMessage {
                Text(message)
                    .appFont(.footnote)
                    .foregroundStyle(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            PPButton(ctaTitle, icon: .checkmark, action: onCommit)
                .disabled(!draft.isValid)
                .opacity(draft.isValid ? 1 : 0.5)
        }
        .screenPadding()
        .padding(.vertical, AppSpacing.lg)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Add sheet

/// Modal creation flow for a new pantry item.
struct AddPantryItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppContainer.self) private var container

    @State private var draft = PantryItemDraft()
    @State private var saveFailed = false

    var body: some View {
        NavigationStack {
            PantryItemEditorContent(draft: $draft, ctaTitle: "Add to pantry", onCommit: save)
                .navigationTitle("New ingredient")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                            .foregroundStyle(AppColor.textSecondary)
                    }
                }
        }
        .alert("Couldn't save the item", isPresented: $saveFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong while saving. Please try again.")
        }
    }

    private func save() {
        do {
            container.dataStore.insert(draft.makeItem())
            try container.dataStore.save()
            container.haptics.play(.success)
            dismiss()
        } catch {
            AppLogger.persistence.error("Failed to add pantry item: \(error)")
            container.haptics.play(.error)
            saveFailed = true
        }
    }
}

// MARK: - Detail / edit

/// Pushed editor for an existing item, resolved by its stable `id` so the
/// route stays value-based.
struct PantryItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppContainer.self) private var container
    @Query private var items: [PantryItem]

    @State private var draft = PantryItemDraft()
    @State private var draftLoaded = false
    @State private var confirmingDelete = false
    @State private var saveFailed = false

    init(itemID: UUID) {
        _items = Query(filter: #Predicate<PantryItem> { $0.id == itemID })
    }

    var body: some View {
        Group {
            if let item = items.first {
                PantryItemEditorContent(draft: $draft, ctaTitle: "Save changes") {
                    save(item)
                }
                .onAppear {
                    guard !draftLoaded else { return }
                    draft = PantryItemDraft(item: item)
                    draftLoaded = true
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            confirmingDelete = true
                        } label: {
                            AppIcon.delete.image.foregroundStyle(AppColor.error)
                        }
                        .accessibilityLabel("Delete item")
                    }
                }
                .confirmationDialog(
                    "Delete \(item.name)?",
                    isPresented: $confirmingDelete,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) { delete(item) }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This removes it from your pantry.")
                }
            } else {
                // The item was deleted elsewhere while this screen was open.
                EmptyStateView(icon: .empty, title: "Item removed",
                               message: "This ingredient is no longer in your pantry.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColor.background)
            }
        }
        .navigationTitle(items.first?.name ?? "Item")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Couldn't save the item", isPresented: $saveFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong while saving. Please try again.")
        }
    }

    private func save(_ item: PantryItem) {
        do {
            draft.apply(to: item)
            try container.dataStore.save()
            container.haptics.play(.success)
            dismiss()
        } catch {
            AppLogger.persistence.error("Failed to save pantry item: \(error)")
            container.haptics.play(.error)
            saveFailed = true
        }
    }

    private func delete(_ item: PantryItem) {
        do {
            container.dataStore.delete(item)
            try container.dataStore.save()
            container.haptics.play(.success)
            dismiss()
        } catch {
            AppLogger.persistence.error("Failed to delete pantry item: \(error)")
            container.haptics.play(.error)
            saveFailed = true
        }
    }
}

#Preview("Add") {
    AddPantryItemSheet()
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.preview)
}

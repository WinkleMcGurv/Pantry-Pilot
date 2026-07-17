//
//  PantryItemForm.swift
//  PantryPilot
//
//  The editable draft of a pantry item and the shared form fields used by both
//  the add sheet and the detail editor. Edits happen on the value-type draft
//  and are only applied to the persistent model on save, so cancelling never
//  mutates live data.
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - Draft

/// A value-type working copy of a ``PantryItem``.
struct PantryItemDraft {
    var name = ""
    var quantityText = "1"
    var unit: MeasurementUnit = .pieces
    var storageLocation: StorageLocation = .pantry
    var category: ShoppingCategory = .other
    var hasExpiry = false
    var expiryDate = Calendar.current.date(byAdding: .day, value: 3, to: .now) ?? .now
    var barcode = ""
    var photoData: Data?

    init() {}

    init(item: PantryItem) {
        name = item.name
        quantityText = Self.format(quantity: item.quantity)
        unit = item.unit
        storageLocation = item.storageLocation
        category = item.category
        if let expiry = item.expiryDate {
            hasExpiry = true
            expiryDate = expiry
        }
        barcode = item.barcode ?? ""
        photoData = item.photoData
    }

    // MARK: Parsing & validation

    var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var quantity: Double? {
        Double(quantityText.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "."))
    }

    var isValid: Bool { validationMessage == nil }

    /// Why the draft can't be saved yet, or `nil` when it can.
    var validationMessage: String? {
        if trimmedName.isEmpty { return "Give the ingredient a name." }
        guard let quantity, quantity > 0, quantity <= 100_000 else {
            return "Quantity must be a number greater than zero."
        }
        return nil
    }

    // MARK: Applying

    /// Writes the draft's values onto a persistent item.
    func apply(to item: PantryItem) {
        item.name = trimmedName
        item.quantity = quantity ?? item.quantity
        item.unit = unit
        item.storageLocation = storageLocation
        item.category = category
        item.expiryDate = hasExpiry ? expiryDate : nil
        let trimmedBarcode = barcode.trimmingCharacters(in: .whitespaces)
        item.barcode = trimmedBarcode.isEmpty ? nil : trimmedBarcode
        item.photoData = photoData
    }

    /// Builds a new persistent item from the draft.
    func makeItem() -> PantryItem {
        let item = PantryItem(name: trimmedName)
        apply(to: item)
        return item
    }

    private static func format(quantity: Double) -> String {
        quantity.formatted(.number.precision(.fractionLength(0...2)).grouping(.never))
    }
}

// MARK: - Form fields

/// The pantry item form body: name, quantity & unit, storage, category,
/// expiry, photo and barcode. Hosted inside `PantryItemEditorContent`.
struct PantryItemFormFields: View {
    @Binding var draft: PantryItemDraft
    @Environment(AppContainer.self) private var container
    @FocusState private var focusedField: Field?
    @State private var photoSelection: PhotosPickerItem?

    private enum Field { case name, quantity, barcode }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxl) {
            PPTextField(title: "Name", icon: .pantry, placeholder: "e.g. Chicken breast", text: $draft.name)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .quantity }

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                PPTextField(title: "Quantity", placeholder: "e.g. 500", keyboard: .decimalPad, text: $draft.quantityText)
                    .focused($focusedField, equals: .quantity)
                OnboardingChipGrid(
                    options: MeasurementUnit.allCases,
                    title: \.abbreviation,
                    isSelected: { draft.unit == $0 },
                    onToggle: { unit in
                        container.haptics.play(.selection)
                        draft.unit = unit
                    }
                )
            }

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader(title: "Stored in")
                OnboardingChipGrid(
                    options: StorageLocation.allCases,
                    title: \.title,
                    isSelected: { draft.storageLocation == $0 },
                    onToggle: { location in
                        container.haptics.play(.selection)
                        draft.storageLocation = location
                    }
                )
            }

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SectionHeader(title: "Shopping category", subtitle: "Groups this item on shopping lists")
                OnboardingChipGrid(
                    options: ShoppingCategory.allCases,
                    title: \.title,
                    isSelected: { draft.category == $0 },
                    onToggle: { category in
                        container.haptics.play(.selection)
                        draft.category = category
                    }
                )
            }

            expirySection
            photoSection

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                PPTextField(title: "Barcode (optional)", icon: .barcode, placeholder: "e.g. 5000168001234", keyboard: .numberPad, text: $draft.barcode)
                    .focused($focusedField, equals: .barcode)
                Text("Barcode scanning arrives with a later premium update.")
                    .appFont(.caption)
                    .foregroundStyle(AppColor.textTertiary)
            }
        }
        .keyboardDoneToolbar(isActive: focusedField != nil && focusedField != .name) {
            focusedField = nil
        }
    }

    // MARK: Expiry

    private var expirySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Toggle(isOn: $draft.hasExpiry.animation(.snappy(duration: 0.25))) {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("Expiry date")
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                    Text("Get it used (or flagged) before it turns")
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
            .tint(AppColor.brand)
            .padding(AppSpacing.lg)
            .background(AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                    .strokeBorder(AppColor.separator, lineWidth: 0.5)
            )

            if draft.hasExpiry {
                DatePicker("Expires on", selection: $draft.expiryDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .tint(AppColor.brand)
                    .appFont(.body)
                    .padding(AppSpacing.lg)
                    .background(AppColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                            .strokeBorder(AppColor.separator, lineWidth: 0.5)
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: Photo

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Photo", subtitle: "Optional — handy for lookalike jars")

            HStack(spacing: AppSpacing.md) {
                if let data = draft.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                        .accessibilityLabel("Item photo")

                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        Text("Change")
                            .appFont(.subheadline)
                            .foregroundStyle(AppColor.brand)
                    }

                    Button("Remove", role: .destructive) {
                        withAnimation(.snappy(duration: 0.2)) { draft.photoData = nil }
                    }
                    .appFont(.subheadline)
                    .foregroundStyle(AppColor.error)
                } else {
                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        Label("Add photo", icon: .camera)
                            .appFont(.subheadline)
                            .foregroundStyle(AppColor.brand)
                            .padding(.horizontal, AppSpacing.lg)
                            .frame(height: 40)
                            .background(AppColor.brandSoft)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .onChange(of: photoSelection) { _, selection in
            guard let selection else { return }
            Task {
                if let data = try? await selection.loadTransferable(type: Data.self),
                   let downscaled = Self.downscaled(imageData: data) {
                    withAnimation(.snappy(duration: 0.2)) { draft.photoData = downscaled }
                }
                photoSelection = nil
            }
        }
    }

    /// Re-encodes the picked image capped at 1200px on the long edge so the
    /// store (external storage) stays lean.
    private static func downscaled(imageData: Data, maxDimension: CGFloat = 1200) -> Data? {
        guard let image = UIImage(data: imageData) else { return nil }
        let largest = max(image.size.width, image.size.height)
        guard largest > maxDimension else { return image.jpegData(compressionQuality: 0.75) }
        let scale = maxDimension / largest
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
        return resized.jpegData(compressionQuality: 0.75)
    }
}

#Preview {
    @Previewable @State var draft = PantryItemDraft()
    return ScrollView {
        PantryItemFormFields(draft: $draft)
            .padding()
    }
    .background(AppColor.background)
    .environment(AppContainer.preview())
}

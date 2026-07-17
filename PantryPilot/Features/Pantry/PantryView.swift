//
//  PantryView.swift
//  PantryPilot
//
//  Root of the Pantry tab: the ingredient inventory grouped by storage
//  location, sorted so the soonest-expiring items surface first.
//

import SwiftUI
import SwiftData
import UIKit

struct PantryView: View {
    @Environment(AppContainer.self) private var container
    @Query private var items: [PantryItem]

    @State private var isAddingItem = false

    var body: some View {
        Group {
            if items.isEmpty {
                EmptyStateView(
                    icon: .pantry,
                    title: "Your pantry is empty",
                    message: "Add ingredients you already have so the planner can cook from them first.",
                    actionTitle: "Add ingredient"
                ) {
                    isAddingItem = true
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColor.background)
            } else {
                inventoryList
            }
        }
        .navigationTitle("Pantry")
        .rootToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { isAddingItem = true } label: { AppIcon.add.image }
                    .accessibilityLabel("Add ingredient")
            }
        }
        .sheet(isPresented: $isAddingItem) {
            AddPantryItemSheet()
        }
    }

    // MARK: List

    /// Sections in canonical storage order, soonest expiry first within each.
    private var groupedItems: [(location: StorageLocation, items: [PantryItem])] {
        StorageLocation.allCases.compactMap { location in
            let sectionItems = items
                .filter { $0.storageLocation == location }
                .sorted {
                    let lhs = $0.expiryDate ?? .distantFuture
                    let rhs = $1.expiryDate ?? .distantFuture
                    return lhs == rhs
                        ? $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                        : lhs < rhs
                }
            return sectionItems.isEmpty ? nil : (location, sectionItems)
        }
    }

    private var inventoryList: some View {
        List {
            ForEach(groupedItems, id: \.location) { group in
                Section {
                    ForEach(group.items) { item in
                        PantryItemRow(item: item)
                            .listRowBackground(AppColor.surface)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    delete(item)
                                } label: {
                                    Label("Delete", icon: .delete)
                                }
                            }
                    }
                } header: {
                    Text("\(group.location.title) · \(group.items.count)")
                        .appFont(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                        .textCase(nil)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppColor.background)
    }

    private func delete(_ item: PantryItem) {
        do {
            container.dataStore.delete(item)
            try container.dataStore.save()
            container.haptics.play(.success)
        } catch {
            AppLogger.persistence.error("Failed to delete pantry item: \(error)")
            container.haptics.play(.error)
        }
    }
}

// MARK: - Row

private struct PantryItemRow: View {
    let item: PantryItem

    var body: some View {
        NavigationLink(value: AppRoute.pantryItemDetail(itemID: item.id)) {
            HStack(spacing: AppSpacing.md) {
                thumbnail

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(item.name)
                        .appFont(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(1)
                    Text(subtitle)
                        .appFont(.footnote)
                        .foregroundStyle(AppColor.textSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: AppSpacing.sm)

                if let badge = expiryBadge {
                    PPBadge(text: badge.text, icon: .expiry, tone: badge.tone)
                }
            }
            .padding(.vertical, AppSpacing.xs)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }

    private var thumbnail: some View {
        Group {
            if let data = item.photoData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                AppIcon.pantry.image
                    .font(.body.weight(.medium))
                    .foregroundStyle(AppColor.brand)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColor.brandSoft)
            }
        }
        .frame(width: 44, height: 44)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous))
        .accessibilityHidden(true)
    }

    private var subtitle: String {
        var parts = [quantityText]
        if let expiryDate = item.expiryDate, expiryBadge == nil {
            parts.append("Expires \(expiryDate.formatted(.dateTime.day().month(.abbreviated)))")
        }
        return parts.joined(separator: " · ")
    }

    private var quantityText: String {
        let amount = item.quantity.formatted(.number.precision(.fractionLength(0...2)))
        return "\(amount) \(item.unit.abbreviation)"
    }

    /// Badge for urgent expiry states only; calmer dates live in the subtitle.
    private var expiryBadge: (text: String, tone: PPBadgeTone)? {
        guard let days = item.daysUntilExpiry else { return nil }
        switch days {
        case ..<0:   return ("Expired", .error)
        case 0:      return ("Today", .warning)
        case 1:      return ("1 day", .warning)
        case 2...3:  return ("\(days) days", .warning)
        default:     return nil
        }
    }

    private var accessibilitySummary: String {
        var summary = "\(item.name), \(quantityText)"
        if let badge = expiryBadge {
            summary += badge.text == "Expired" ? ", expired" : ", expires in \(badge.text)"
        } else if let expiryDate = item.expiryDate {
            summary += ", expires \(expiryDate.formatted(date: .abbreviated, time: .omitted))"
        }
        return summary
    }
}

#Preview("Populated") {
    NavigationStack { PantryView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.preview)
}

#Preview("Empty") {
    NavigationStack { PantryView() }
        .environment(AppRouter())
        .environment(AppContainer.preview())
        .modelContainer(PersistenceController.makeContainer(inMemory: true))
}

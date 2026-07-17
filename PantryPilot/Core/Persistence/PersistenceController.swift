//
//  PersistenceController.swift
//  PantryPilot
//
//  Owns the SwiftData `ModelContainer`. Provides the live on-disk container and
//  an in-memory container for previews and tests.
//

import Foundation
import SwiftData

/// Factory for the app's `ModelContainer`.
enum PersistenceController {

    /// Builds a container backed by the given configuration.
    /// - Parameter inMemory: When `true`, data is not persisted to disk
    ///   (used for SwiftUI previews and unit tests).
    static func makeContainer(inMemory: Bool = false) -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: AppSchema.schema,
            isStoredInMemoryOnly: inMemory
        )
        do {
            return try ModelContainer(
                for: AppSchema.schema,
                configurations: [configuration]
            )
        } catch {
            // A failure here means the schema is fundamentally invalid, which is
            // a programmer error we want to surface loudly during development.
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    /// A shared in-memory container for SwiftUI previews.
    @MainActor
    static let preview: ModelContainer = {
        let container = makeContainer(inMemory: true)
        PreviewData.populate(container.mainContext)
        return container
    }()
}

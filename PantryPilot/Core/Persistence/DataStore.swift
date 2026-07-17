//
//  DataStore.swift
//  PantryPilot
//
//  A thin, generic persistence abstraction over `ModelContext`. Feature layers
//  depend on this protocol rather than SwiftData directly, which keeps them
//  testable and decoupled from the storage backend.
//

import Foundation
import SwiftData

/// Generic CRUD operations over persistent models.
@MainActor
protocol DataStore: AnyObject {
    func fetch<T: PersistentModel>(
        _ type: T.Type,
        predicate: Predicate<T>?,
        sortBy: [SortDescriptor<T>]
    ) throws -> [T]

    func insert<T: PersistentModel>(_ model: T)
    func delete<T: PersistentModel>(_ model: T)
    func save() throws
}

extension DataStore {
    /// Fetches all models of a type with no filtering.
    func fetchAll<T: PersistentModel>(_ type: T.Type) throws -> [T] {
        try fetch(type, predicate: nil, sortBy: [])
    }
}

/// `DataStore` backed by a SwiftData `ModelContext`.
@MainActor
final class SwiftDataStore: DataStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetch<T: PersistentModel>(
        _ type: T.Type,
        predicate: Predicate<T>? = nil,
        sortBy: [SortDescriptor<T>] = []
    ) throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        return try context.fetch(descriptor)
    }

    func insert<T: PersistentModel>(_ model: T) {
        context.insert(model)
    }

    func delete<T: PersistentModel>(_ model: T) {
        context.delete(model)
    }

    func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

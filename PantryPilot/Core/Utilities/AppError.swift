//
//  AppError.swift
//  PantryPilot
//
//  A shared error type surfaced to the UI with user-facing messaging.
//

import Foundation

/// Application-level errors that can be presented to the user.
enum AppError: LocalizedError, Equatable {
    /// A capability that is planned but not yet implemented in this build.
    case notImplemented(feature: String)
    case persistence(String)
    case network(String)
    case invalidInput(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .notImplemented(let feature):
            return "\(feature) isn't available yet."
        case .persistence(let message):
            return "Something went wrong saving your data. \(message)"
        case .network(let message):
            return "A network problem occurred. \(message)"
        case .invalidInput(let message):
            return message
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

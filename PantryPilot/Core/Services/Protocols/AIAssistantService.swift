//
//  AIAssistantService.swift
//  PantryPilot
//
//  The contract for AI-powered helpers: pantry recipe suggestions, ingredient
//  substitutions, nutrition advice and the cooking assistant. Implemented in a
//  later phase.
//

import Foundation

/// AI assistant capabilities used across the app.
protocol AIAssistantService {
    /// Suggests recipes that make good use of the given pantry items.
    func suggestRecipes(fromPantry items: [PantryItem]) async throws -> [Recipe]

    /// Suggests substitutions for an ingredient the user lacks or dislikes.
    func substitutions(for ingredient: String) async throws -> [String]

    /// Answers a free-form cooking/nutrition question.
    func answer(question: String) async throws -> String
}

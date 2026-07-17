//
//  AppLogger.swift
//  PantryPilot
//
//  Lightweight wrappers around `os.Logger` for consistent, categorised logging.
//

import Foundation
import os

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.gurv.PantryPilot"

    static let app = Logger(subsystem: subsystem, category: "app")
    static let persistence = Logger(subsystem: subsystem, category: "persistence")
    static let navigation = Logger(subsystem: subsystem, category: "navigation")
    static let services = Logger(subsystem: subsystem, category: "services")
}

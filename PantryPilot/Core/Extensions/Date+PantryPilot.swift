//
//  Date+PantryPilot.swift
//  PantryPilot
//
//  Date helpers used by the planner and calendar.
//

import Foundation

extension Date {
    /// The start of the week (Monday) containing this date.
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        var cal = calendar
        cal.firstWeekday = 2 // Monday
        let components = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return cal.date(from: components) ?? self
    }

    /// An array of the seven dates in the week containing this date.
    func weekDates(using calendar: Calendar = .current) -> [Date] {
        let start = startOfWeek(using: calendar)
        return (0..<AppConstants.daysPerWeek).compactMap {
            calendar.date(byAdding: .day, value: $0, to: start)
        }
    }

    /// Whether this date falls on today.
    var isToday: Bool { Calendar.current.isDateInToday(self) }
}

//
//  Date+Extensions.swift
//  TaskManagement
//
//  Created by Jacek Kosinski U on 26/09/2023.
//

import SwiftUI

/// Date Extensions Needed for Building UI
extension Date {
    /// Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
    }

    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

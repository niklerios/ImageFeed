//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 28.03.2026.
//

import Foundation

extension Date {
    var dateTimeString: String { DateFormatter.defaultDateTime.string(from: self) }
    
    static func from(_ string: String) -> Date? {
        DateFormatter.iso8601.date(from: string)
    }
}

private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "Ru-ru")

        return formatter
    }()
    
    static let iso8601 = ISO8601DateFormatter()
}

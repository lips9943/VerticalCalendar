//
//  VCMonth.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/25/25.
//
import Foundation

public protocol VCMonth: Equatable {
    var calendar: Calendar { get }
    var locale: Locale { get }
    var date: Date { get }
}

public extension VCMonth {
    var month: Int { calendar.component(.month, from: date) }
    
    var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    var value: String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        return formatter.shortStandaloneMonthSymbols[month - 1]
    }
    
    func weekday(calendar: Calendar) -> Int {
        let firstDate = date.atFirstDayOfMonth(calendar) ?? date
        let weekday = calendar.component(.weekday, from: firstDate)
        return weekday
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.calendar.isDate(lhs.date, equalTo: rhs.date, toGranularity: .month)
    }
}

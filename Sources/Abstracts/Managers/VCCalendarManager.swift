//
//  VCCalendarManager.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/25/25.
//
import Foundation

public protocol VCCalendarManager {
    var calendar: Calendar { get }
    var locale: Locale { get }
    var startDate: Date { get }
    var endDate: Date { get }

    associatedtype MainCalendar: VCCalendar
    func createCalendars() throws(VCError) -> [MainCalendar]
    func createCalendar(at date: Date) throws(VCError) -> MainCalendar
}

public extension VCCalendarManager {
    func create(at date: Date) throws(VCError) -> (Date, [Date]) {
        guard let firstDayOfMonth = date.atFirstDayOfMonth(calendar) else { throw VCCreationError.invalidDateFormat(date) }
        guard let rangeOfDaysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { throw VCCreationError.invalidDateFormat(firstDayOfMonth) }
        var days: [Date] = []
        var dayDate = firstDayOfMonth
        for _ in rangeOfDaysInMonth {
            days.append(dayDate)
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: dayDate) else { throw VCCreationError.invalidDateFormat(dayDate) }
            dayDate = nextDay
        }
        
        return (date, days)
    }
    
    func createEmptyDate(at month: Date) throws(VCError) -> [Date] {
        guard let firstDayOfMonth = month.atFirstDayOfMonth(calendar) else { throw VCCreationError.invalidDateFormat(month) }
        let weekDay = calendar.component(.weekday, from: firstDayOfMonth)
        var items: [Date] = []
        for _ in 1..<weekDay {
            items.append(month)
        }
        return items
    }
}


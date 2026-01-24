//
//  VCIndexingManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/25/25.
//
import UIKit

public actor VCIndexingManager {
    private let calendar: Calendar
    public init(calendar: Calendar) {
        self.calendar = calendar
    }
    
    /// return Index that has the same with one of the Calendar's date
    public func findIndex(ofMonth date: Date, in calendars: [any VCCalendar]) -> Int? {
        guard !calendars.isEmpty, let firstMonth = calendars.first?.month.date else { return nil }
        let from = firstMonth.atFirstDayOfMonth(calendar) ?? firstMonth
        let to = date.atFirstDayOfMonth(calendar) ?? date
        let betweenMonth = calendar.dateComponents([.month], from: from, to: to).month ?? 0
        return betweenMonth
    }
    
    /// return index that has the same with one of the Days in Calendar
    public func findIndex(ofDay date: Date, in calendar: any VCCalendar) -> Int? {
        guard !calendar.days.isEmpty, let firstDayofMonth = date.atFirstDayOfMonth(self.calendar) else { return nil }
        let days = calendar.days
        let weekday = self.calendar.component(.weekday, from: firstDayofMonth) - 1
        let index = self.calendar.component(.day, from: date) - 1
        let result = index + weekday
        guard days.count > result else { return nil }
        return index + weekday
    }
    
    public func findToday(in calendars: [any VCCalendar]) -> IndexPath? {
        findIndexPathAtPrevMonth(by: Date(), in: calendars)
    }
    
    private func findIndexPathAtPrevMonth(by date: Date, in calendars: [any VCCalendar]) -> IndexPath? {
        guard let firstCalendar = calendars.first else { return nil }
        let firstDate = firstCalendar.month.date
        let betweenMonthCount = calendar.dateComponents([.month], from: firstDate, to: date).month ?? 0
        guard betweenMonthCount <= calendars.count, betweenMonthCount > 0 else { return nil }
        let calendarOfToday = calendars[betweenMonthCount - 1]
        return IndexPath(item: calendarOfToday.days.count - 1, section: betweenMonthCount - 1)
    }
}

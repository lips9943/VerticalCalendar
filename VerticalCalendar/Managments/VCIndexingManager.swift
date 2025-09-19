//
//  VCIndexingManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/25/25.
//
import UIKit

public struct VCIndexingManager {
    private let calendar: Calendar
    public init(calendar: Calendar) {
        self.calendar = calendar
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

//
//  VCCalendarCreator.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/2/25.
//
import Foundation

public struct VCDefaultCalendarManager: VCCalendarManager {
    private var _startDate: Date
    private var _endDate: Date
    
    public var calendar: Calendar
    public var locale: Locale
    public var startDate: Date { _startDate }
    public var endDate: Date { _endDate }
    
    init(startDate: Date, endDate: Date, calendar: Calendar, locale: Locale) {
        self.calendar = calendar
        self.locale = locale
        self._startDate = startDate
        self._endDate = endDate
    }
    
    public func createCalendars() throws(VCError) -> [VCDefalutCalendar] {
        guard let start = calendar.date(byAdding: .month, value: -1, to: startDate) else { throw VCCreationError.invalidDateFormat(startDate) }
        guard let end = calendar.date(byAdding: .month, value: 1, to: endDate) else { throw VCCreationError.invalidDateFormat(endDate) }
        var dates: any Sequence<Date>
        if #available(iOS 18, *) {
            let range = Range<Date>.init(uncheckedBounds: (start, end))
            dates = calendar.dates(byAdding: .month, startingAt: start, in: range)
        } else {
            var arrayOfDate: [Date] = []
            var targetDate = startDate
            while !targetDate.isSameMonth(as: endDate) {
                arrayOfDate.append(targetDate)
                guard let newTarget = calendar.date(byAdding: DateComponents(month: 1), to: targetDate) else { break }
                targetDate = newTarget
            }
            dates = arrayOfDate
        }
        var calendars: [VCDefalutCalendar] = []
        for date in dates {
            let calendar = try createCalendar(at: date)
            calendars.append(calendar)
        }
        return calendars
    }
    
    public func createCalendar(at date: Date) throws(VCError) -> VCDefalutCalendar {
        let calendar = try self.create(at: date)
        let month = VCDefalutMonth(calendar: self.calendar, locale: locale, date: calendar.0)
        let days: [VCDefalutDay] = try self.createEmptyDate(at: date)
            .map { VCDefalutDay(calendar: self.calendar, locale: locale, date: $0, isPrevMonthDay: true)} + calendar.1
            .map { VCDefalutDay(calendar: self.calendar, locale: locale, date: $0, isPrevMonthDay: false)}
        
        return VCDefalutCalendar(month: month, days: days)
    }
}

//import Playgrounds
//#Playground {
//    let date = Date()
//    let calendar = Calendar.current
//    let result = calendar.date(byAdding: DateComponents(month: 1), to: date)
//}

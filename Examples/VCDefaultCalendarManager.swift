//
//  VCTestCalendarManager.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import Foundation

struct VCDefaultCalendarManager: VCCalendarManager {
    private var _startDate: Date
    private var _endDate: Date
    
    var calendar: Calendar
    var locale: Locale
    var startDate: Date { _startDate }
    var endDate: Date { _endDate }
    
    init(startDate: Date, endDate: Date, calendar: Calendar, locale: Locale) {
        self.calendar = calendar
        self.locale = locale
        self._startDate = startDate
        self._endDate = endDate
    }
    
    init() {
        self.calendar = Calendar.current
        self.locale = Locale.current
        let defaultDate = Date()
        self._startDate = calendar.date(byAdding: .year, value: -60, to: defaultDate)!
        self._endDate = calendar.date(byAdding: .year, value: 60, to: defaultDate)!
    }
    
    func createCalendars() throws(VCError) -> [VCDefaultCalendar] {
        var calendars: [VCDefaultCalendar] = []
        var currentDate = startDate
        while currentDate <= endDate {
            calendars.append(try createCalendar(at: currentDate))
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        return calendars
    }
    
    func createCalendar(at date: Date) throws(VCError) -> VCDefaultCalendar {
        let calendar = try self.create(at: date)
        let month = VCDefaultMonth(calendar: self.calendar, locale: locale, date: calendar.0)
        let days: [VCDefaultDay] = try self.createEmptyDate(at: date)
            .map { VCDefaultDay(calendar: self.calendar, locale: locale, date: $0, isPrevMonthDay: true)} + calendar.1
            .map { VCDefaultDay(calendar: self.calendar, locale: locale, date: $0, isPrevMonthDay: false)}
        
        return VCDefaultCalendar(month: month, days: days)
    }
}

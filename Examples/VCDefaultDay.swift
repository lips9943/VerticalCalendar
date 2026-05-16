//
//  VCTestDay.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import Foundation

final class VCDefaultDay: VCDay {
    var calendar: Calendar
    var locale: Locale
    private var _date: Date
    var date: Date { _date }
    
    private var _isPrevMonthDay: Bool
    var isPrevMonthDay: Bool { _isPrevMonthDay }
    
    init(calendar: Calendar, locale: Locale, date: Date, isPrevMonthDay: Bool) {
        self.calendar = calendar
        self.locale = locale
        self._date = date
        self._isPrevMonthDay = isPrevMonthDay
    }
}

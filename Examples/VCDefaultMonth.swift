//
//  VCTestMonth.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import Foundation

final class VCDefaultMonth: VCMonth {
    var calendar: Calendar
    var locale: Locale
    private var _date: Date
    var date: Date { _date }
    
    init(calendar: Calendar, locale: Locale, date: Date) {
        self.calendar = calendar
        self.locale = locale
        self._date = date
    }
}

//
//  VCTestMonth.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import Foundation

public final class VCDefaultMonth: VCMonth {
    public var calendar: Calendar
    public var locale: Locale
    private var _date: Date
    public var date: Date { _date }
    
    public init(calendar: Calendar, locale: Locale, date: Date) {
        self.calendar = calendar
        self.locale = locale
        self._date = date
    }
}

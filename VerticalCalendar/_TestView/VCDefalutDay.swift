//
//  VCDay.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/2/25.
//
import Foundation

final class VCDefalutDay: VCDay {
    public var calendar: Calendar
    public var locale: Locale
    private var _date: Date
    public var date: Date { _date }
    
    private var _isPrevMonthDay: Bool
    public var isPrevMonthDay: Bool { _isPrevMonthDay }
    
    init(calendar: Calendar, locale: Locale, date: Date, isPrevMonthDay: Bool) {
        self.calendar = calendar
        self.locale = locale
        self._date = date
        self._isPrevMonthDay = isPrevMonthDay
    }
}

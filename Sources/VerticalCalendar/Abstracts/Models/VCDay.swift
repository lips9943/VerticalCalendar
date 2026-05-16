//
//  VCDay.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/25/25.
//
import Foundation

public protocol VCDay: Equatable {
    var calendar: Calendar { get }
    var locale: Locale { get }
    var date: Date { get }
    /// 이전 달의 일이 포함된 날짜라면 true
    var isPrevMonthDay: Bool { get }
    var isFirstDayOfMonth: Bool { get }
    var isFirstDayOfWeek: Bool { get}
    
    func isSameDay(as date: Date) -> Bool
}

public extension VCDay {
    var isToday: Bool { calendar.isDateInToday(date) }
    var day: Int { calendar.component(.day, from: date) }
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.calendar.isDate(lhs.date, equalTo: rhs.date, toGranularity: .day)
    }
    
    var isFirstDayOfMonth: Bool {
        let day = calendar.component(.day, from: date)
        return day == 1
    }
    
    var isFirstDayOfWeek: Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1
    }
    
    func isSameDay(as date: Date) -> Bool {
        calendar.isDate(self.date, inSameDayAs: date)
    }
}


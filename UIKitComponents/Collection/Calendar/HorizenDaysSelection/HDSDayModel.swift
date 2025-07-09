//
//  HDSDayModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

struct HDSDayModel {
    let date: Date
    
    var day: Int { date.day }
    var weekDayLabel: String { date.weekdayName(.standaloneShort) }
    var isToday: Bool { date.compare(.isToday) }
    var isWeekend: Bool { date.compare(.isWeekend) }
    var currentMonth: Int { date.month }
    var currentYear: Int { date.year }
}

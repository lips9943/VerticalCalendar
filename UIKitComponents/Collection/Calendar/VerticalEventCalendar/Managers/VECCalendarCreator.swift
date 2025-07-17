//
//  VECDateCreator.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

import DSA
internal import SwiftDate


struct VECCalendarCreator {
    func generateCalendarByDate(_ date: Date) -> VECSection {
        return createCalendar(by: date)
    }
    func generateCalendarByDate(_ date: Date) async -> VECSection {
        return createCalendar(by: date)
    }
    
    func appendCalendarsByDate(_ date: Date, calendarCount: Int = 3) -> [VECSection] {
        return createCalendars(by: date, to: true, calendarCount: calendarCount)
    }
    func appendCalendarsByDate(_ date: Date, calendarCount: Int = 3) async -> [VECSection] {
        return createCalendars(by: date, to: true, calendarCount: calendarCount)
    }
    
    func prependCalendarsByDate(_ date: Date, calendarCount: Int = 3) -> [VECSection] {
        return createCalendars(by: date, to: false, calendarCount: calendarCount)
    }
}

extension VECCalendarCreator {
    /// Date를 받아서 해당 월의 달력을 만듭니다.
    private func createCalendar(by date: Date) -> VECSection {
        let month = VECMonth(date: date)
        var items = [VECDay]()
        var currentDay = date.dateAt(.startOfMonth)
        for _ in 1...date.monthDays {
            items.append(VECDay(date: currentDay))
            currentDay = currentDay.dateAt(.tomorrow)
        }
        
        let prevEmpty = generateEmptyDayByFirstDayOfWeek(date: date)
        return VECSection(month: month, days: prevEmpty + items)
    }
    
    /// Date 달 기준으로 다음달 또는 이전달부터 count에 맞게 생성합니다.
    private func createCalendars(by date: Date, to isAppending: Bool, calendarCount: Int) -> [VECSection] {
        var list = [VECSection]()
        var currentDate = date.dateAt(isAppending ? .nextMonth : .prevMonth)
        for _ in 0..<calendarCount {
            if isAppending {
                list.append(createCalendar(by: currentDate))
            } else {
                list.insert(createCalendar(by: currentDate), at: 0)
            }
            
            currentDate = currentDate.dateAt(isAppending ? .nextMonth : .prevMonth)
        }
        return list
    }
    
    /// Date를 받아 해당 월의 첫날을 가져오고, 첫날의 어느 WeekDay에 속에 있는 지 파악하여 빈 Cell을 생성해 줍니다.
    private func generateEmptyDayByFirstDayOfWeek(date: Date) -> [VECDay] {
        let firstDayOfMonth = date.dateAt(.startOfMonth)
        let weekDay = firstDayOfMonth.dateComponents.weekday!
        var items: [VECDay] = []
        for _ in 1..<weekDay {
            var item = VECDay(date: date)
            item.isEmptyDate = true
            items.append(item)
        }
        return items
    }
}

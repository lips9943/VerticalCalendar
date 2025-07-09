//
//  VECDay.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
internal import SwiftDate

struct VECDay {
    let id: UUID = UUID()
    let date: Date
    var isEmptyDate: Bool = false
    var events: [VECEvent?] = [nil, nil, nil, nil]
    
    var isWeekend: Bool {
        if date.weekday == 1 || date.weekday == 7 {
            return true
        } else {
            return false
        }
    }
    var isSaturday: Bool {
        return date.weekday == 7 ? true : false
    }
    var isSunday: Bool {
        return date.weekday == 1 ? true : false
    }
    
    
    /// Day의 날짜와 이벤트 StartDate와 같은 날 체크.
    func isSameDay(with startDate: Date) -> Bool { date.compare(.isSameDay(startDate)) }
    
    /// Day의 날짜가 이벤트 StarDate와 EndDate 사이에 있는 지 확인하여 Bool 값을 반환
    func isBetween(from startDate: Date, to endDate: Date) -> Bool { startDate.dateAt(.startOfDay) <= date && endDate.dateAt(.endOfDay) >= date && !isEmptyDate
    }
    
    /// 이벤트 중 가장 빠른 StartDate를 반환합니다.
    func earliestEventByStartDate() -> VECEvent? {
        events.compactMap(\.self).min(by: { $0.startDate < $1.startDate })
    }
    
    /// 이벤트 중 가장 느린 EndDate를 반환합니다.
    func latestEventByEndDate() -> VECEvent? {
        events.compactMap(\.self).max(by: { $0.endDate < $1.endDate })
    }
    
    
}



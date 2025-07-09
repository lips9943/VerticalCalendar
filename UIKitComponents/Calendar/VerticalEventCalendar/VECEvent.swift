//
//  VECEvent.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import UIKit
internal import SwiftDate

struct VECEvent {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool = true
    var locationNumber: Int = -1
    var color: UIColor
    
    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date, color: UIColor = .systemOrange.withAlphaComponent(0.9), isAllDay: Bool = true) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.isAllDay = isAllDay
    }
    
    init(event: Event) {
        self.id = event.id
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.color = event.color
        self.isAllDay = event.isAllDay
    }
    
    
    
    var dateLangth: Int? { startDate.difference(in: .day, from: endDate) }
    var startOfDay: Date { startDate.dateAt(.startOfDay) }
    var endOfDay: Date { endDate.dateAt(.endOfDay) }
    
    
    /// startDate가 이번주에 속해 있는 지 확인합니다.
    func isStartDateExsistInThisWeek(_ date: Date) -> Bool {
        return startDate.compare(.isSameWeek(date))
    }
    
    /// endDate가 이번주에 속해 있는 지 확인합니다.
    func isEndDateExsistInThisWeek(_ date: Date) -> Bool {
        return endDate.compare(.isSameWeek(date))
    }
    
    /// 파라미터 Date가 startDate와 endDate 사이에 존재하는 지 확인합니다.
    func isDateBetweenStartAndEndDate(_ date: Date) -> Bool {
        let start = startDate.dateAt(.startOfDay)
        let end = endDate.dateAt(.endOfDay)
        return start...end ~= date
    }
    
    /// 시작 날짜 또는 끝나는 날짜가 date에 속해 있는 달에 있는 지 확인합니다.
    func isEventInThisMonth(_ month: Date) -> Bool {
        startDate.compare(.isSameMonth(month)) || endDate.compare(.isSameMonth(month))
    }
    
    /// 시작과 끝 날짜 사이에 이벤트에 포함되는 지 확인합니다.
    /// 이벤트의 시작 또는 끝 날짜 중 하나라도 포함되면 true를 반환합니다.
    func isBetweenStartAndEndDate(from startDate: Date, to endDate: Date) -> Bool {
        self.startDate.isInRange(date: startDate.dateAt(.startOfDay), and: endDate.dateAt(.endOfDay)) || self.endDate.isInRange(date: startDate.dateAt(.startOfDay), and: endDate.dateAt(.endOfDay)) 
    }
    
    func isSameDay(with date: Date, isStartDate: Bool) -> Bool {
        if isStartDate {
            return startDate.compare(.isSameDay(date))
        } else {
            return endDate.compare(.isSameDay(date))
        }
        
    }
}

// MARK: - Get Calculated Event Data From Preperties
extension VECEvent {
    /// Day 날짜에 맞추어 이벤트 활성화 여부와 이벤트 UI의 길이를 반환합니다.
    func setEventUI(_ date: Date) -> (Bool, Int) {
        return (isAllowToAppearUI(date), calculateEventViewLangth(date))
    }
    
    /// Date를 받아 UI을 적용할 Bool 값을 반환합니다.
    /// 3가지 조건에 맞는 값을 찾습니다.
    /// - 첫번째: 이벤트의 시작 날짜와 같다면 true
    /// - 두번째: Date의 첫번째 Weekday라면 true
    /// - 세번째: Date가 해당 달의 1일 이라면 true
    /// - 위 조건에 해당되지 않는다면 false
    private func isAllowToAppearUI(_ date: Date) -> Bool {
        if date.compare(.isSameDay(startDate.dateAt(.startOfDay))) {
            return true
        } else if date.weekday == 1 {
            return true
        } else if date.day == date.dateAt(.startOfMonth).day {
            return true
        } else {
            return false
        }
    }
    /// Date를 받아 eventView의 길이를 계산 합니다.
    /// - 총 3가지를 조건을 걸어 반환합니다.
    /// 1. 시작 날짜에서의 계산
    /// 2. 주 첫째 날에서의 계산
    /// 3. 달 첫째 날에서의 계산
    private func calculateEventViewLangth(_ date: Date) -> Int {
        guard startDate.dateAt(.startOfDay) <= date.dateAt(.startOfDay), endDate.dateAt(.startOfDay) >= date.dateAt(.startOfDay) else { return 0 }
        let leftDay = differenceBetweenInEndDateWithDay(date)
        let lastDayOfWeek = date.lastDayOfWeek < date.day ? date.dateAt(.endOfMonth).day : date.lastDayOfWeek
        let endOfWeek = lastDayOfWeek - date.day

        if leftDay >= endOfWeek {
            return endOfWeek + 1
        } else {
            return leftDay + 1
        }
    }
    
    /// 이벤트가 끝나는 날짜와 현재 Day의 Date와 며칠의 차이가 나는 지 계산하여 반환합니다.
    private func differenceBetweenInEndDateWithDay(_ date: Date) -> Int {
        guard let day = date.difference(in: .day, from: endDate) else { return 0 }
        return day
    }
}

// MARK: - Makes Event Follow To UIs

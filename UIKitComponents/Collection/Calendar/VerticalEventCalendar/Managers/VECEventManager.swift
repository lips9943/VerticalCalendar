//
//  VECEventManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/5/25.
//
import UIKit
internal import SwiftDate

actor VECEventManager {
    /// 파라미터 Date를 받아와 속해 있는 달에 이벤트를 골라내어 반환합니다.
    /// startDate와 endDate 둘 중 하나라도 속해있다면 포함됩니다.
    func filter(events: [VECEvent], at month: Date) -> [VECEvent] {
        var filteredEvents: [VECEvent] = []
        
        for event in events {
            if event.isEventInThisMonth(month) {
                filteredEvents.append(event)
            }
        }
        
        return filteredEvents
    }
    
    /// 모든 이벤트들을 정렬하고, UI에 맞게 Location Number을 지정합니다.
    func calculateEventLayoutPositions(events: inout [VECEvent]) {
        guard !events.isEmpty else { return }
        // 이벤트를 시작 날짜 기준으로 정렬
        let sortedEvents = sortEventsInOrderStartDate(events: events)
        
//        let filteredEvent = filterWeekDayCount(with: sortedEvents)
        // 정렬 및 위치 재계산된 이벤트로 교체
        events = assignLocationNumber(in: sortedEvents)
    }
    
    
    /// 이벤트를 startDate가 빠른 순으로 정렬하고, 같은 날짜라면, endDate가 긴 순서로 추가적으로 정렬합니다.
    private func sortEventsInOrderStartDate(events: [VECEvent]) -> [VECEvent] {
        events.sorted {
            if $0.startDate.compare(.isSameDay($1.startDate)) {
                let prevDiffer = $0.startDate.difference(in: .day, from: $0.endDate)
                let currDiffer = $1.startDate.difference(in: .day, from: $1.endDate)
                guard let prevDiffer, let currDiffer else { return $0.startDate < $1.startDate}
                return prevDiffer > currDiffer
            } else {
                return $0.startDate < $1.startDate
            }
        }
    }
    
    /// 이벤트의 길이가 다음주로 넘어가고, 영향을 받는 이벤트들만 불러옵니다.
    private func filterWeekDayCount(with events: [VECEvent]) -> [VECEvent: Int] {
        var result: [VECEvent: Int] = [:]
        let eventInWeeks = events.enumerated().filter {
            let value = $1.weekDayCount > 0
            if value { result[$1] = $0 }
            return value
        }.map {$0.element}
        
        
        for event in eventInWeeks {
            events.enumerated().forEach {
                if $1.isConflictingEventDates(event), !eventInWeeks.contains($1), $1.startDate > event.startDate {
                    result[$1] = $0
                }
            }
        }
        
        return result
    }
    
    
    /// 정렬된 이벤트 순서, UI에 맞는 Index를 Location Number에 할당합니다.
    private func assignLocationNumber(in sortedEvents: [VECEvent]) -> [VECEvent] {
        var activeEvents: [(VECEvent, Int)] = []
        var updatedEvents: [VECEvent] = []

        for var event in sortedEvents {
            // 기존 activeEvents에서 이 이벤트와 겹치지 않는 것들만 유지
            activeEvents = activeEvents.filter {
                Calendar.current.isDate($0.0.endDate, inSameDayAs: event.startDate) ||
                $0.0.endDate > event.startDate
            }

            // 현재 가능한 location 번호 찾기
            let usedLocations = Set(activeEvents.map { $0.1 })
            var location = 0
            while usedLocations.contains(location) {
                location += 1
            }
            
            // locationNumber 할당
            event.locationNumber = location

            // activeEvents에 현재 이벤트 추가
            activeEvents.append((event, location))

            // 업데이트된 이벤트 저장
            updatedEvents.append(event)
        }
        
        return updatedEvents
    }
}
// MARK: - Managing Groups
extension VECEventManager {
    /// - 추가적으로 적용되는 기능
    /// 1. 그룹의 date를 확인하여, 이벤트와 비교해서 그룹이 존재한다면 추가.
    func add(event: VECEvent, in groups: inout [VECEventGroup]) {
        for date in event.getDatesOfMonth {
            put(event: event, in: &groups, on: date)
        }
    }
    
    func add(events: [VECEvent], in groups: inout [VECEventGroup]) {
        for date in getDates(from: events) {
            put(events: events, in: &groups, on: date)
        }
    }
    
    func delete(event id: String, between dates: [Date], in groups: inout [VECEventGroup]) {
        for date in dates {
            guard let index = groups.firstIndex(where: {$0 == date}) else { continue }
            let _ = groups[index].remove(where: {$0.ekEventID == id})
        }
    }
    
    private func put(event: VECEvent, in groups: inout [VECEventGroup], on date: Date) {
        let index = groups.firstIndex { $0 == date }
        if let index = index {
            groups[index].insert(event)
        } else {
            groups.append(VECEventGroup(date: date, events: [event]))
        }
    }
    
    private func put(events: [VECEvent], in groups: inout [VECEventGroup], on date: Date) {
        let filteredEvents: [VECEvent] = events.filter { $0.isEventInThisMonth(date) }
        let index = groups.firstIndex { $0 == date }
        if let index = index {
            groups[index].insert(contentsOf: filteredEvents)
        } else {
            groups.append(VECEventGroup(date: date, events: events))
        }
    }
    
    private func getDates(from events: [VECEvent]) -> [Date] {
        var dates: Set<Date> = []
        for event in events {
            dates.formUnion(event.getDatesOfMonth)
        }
        return Array(dates)
    }
}

//
//  VECEventManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/5/25.
//
import UIKit
internal import SwiftDate

struct VECEventManager {
    /// 파라미터 Date를 받아와 속해 있는 달에 이벤트를 골라내어 반환합니다.
    /// startDate와 endDate 둘 중 하나라도 속해있다면 포함됩니다.
    func findEventsAtMonth(_ events: [VECEvent], month: Date) -> [VECEvent] {
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
        // 이벤트를 시작 날짜 기준으로 정렬
        let sortedEvents = sortEventsInOrderStartDate(events: events)
        
        let filteredEvent = filterWeekDayCount(with: sortedEvents)
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
//    
//    private func a(events: [VECEvent]) -> [VECEvent] {
//        var updatedEvents: [VECEvent] = []
//
//        for event in events {
//            guard event.weekDayCount > 0 else {
//                updatedEvents.append(event)
//                continue
//            }
//            var currentWeekCount: Int = 1
//            
//            // 1. 이벤트들을 현재 이벤트 날짜에 맞게 필터링 합니다.
//            let filteredEvents = events.filter { $0.isConflictingEventDates(event)}
//            
//            // 2. 현재 이벤트가 여러개의 주를 포함할 수 있으니, 각주마다 실행할 while문을 작성합니다.
//            while let currentWeek = event.getDateByWeeks(count: currentWeekCount) {
//                // 3. 필터링 된 이벤트를 한번 더 각주에 포함된 이벤트로 필터링합니다.
//                let currentEndWeek = currentWeek.dateAt(.endOfWeek) > event.endDate ? event.endDate : currentWeek.dateAt(.endOfWeek)
//                var weeklyFilteredEvents = filteredEvents.filter { $0.isInRange(from: currentWeek, to: currentEndWeek) }
//                
//                // 4. 현재 이벤트에 맞는 주의 포함된 이벤트들을 startDate에 맞게 LocationNumber에 추가합니다.
//                weeklyFilteredEvents = sortEventsInOrderStartDate(events: weeklyFilteredEvents)
//                
//                var activeEvents: [(VECEvent, Int)] = []
//                
//                let newEvent = weeklyFilteredEvents.map {
//                    var weeklyFilteredEvent = $0
//                    if let weekIndex = weeklyFilteredEvent.getWeekNumberBy(date: currentWeek), weekIndex > 0 {
//                        activeEvents = activeEvents.filter { $0.0.endDate.compare(.isSameDay(weeklyFilteredEvent.startDate)) || $0.0.endDate > weeklyFilteredEvent.startDate}
//                        
//                        // 현재 가능한 location 번호 찾기
//                        let usedLocations = Set(activeEvents.map { $0.1 })
//                        var location = 0
//                        while usedLocations.contains(location) {
//                            location += 1
//                        }
//                        
//                        // locationNumber 할당
//                        weeklyFilteredEvent.locationNumbers.append(location)
//
//                        // activeEvents에 현재 이벤트 추가
//                        activeEvents.append((event, location))
//                        
//                        return weeklyFilteredEvent
//                    } else {
//                        
//                    }
//                }
//                
//                currentWeekCount += 1
//            }
//        }
//        
//        return updatedEvents
//    }
//    
//    
//    private func b (date: Date, events: [VECEvent]) -> [VECEvent] {
//        events.map {
//            if let weekNum = $0.getWeekNumberBy(date: date), weekNum > 0 {
//                
//            } else {
//                
//            }
//        }
//    }
}

extension VECEventManager {
    func test() -> [VECEvent] {
        let title = ["test1", "test2", "test3", "test4"]
        let color: [UIColor] = [.red, .green, .blue, .purple, .orange, .brown, .cyan, .magenta]
        let events: [VECEvent] = [
            .init(title: title.randomElement()!,
                  startDate: "2025.05.02".toDate()!.date,
                  endDate: "2025.05.03".toDate()!.date,
                  color: color.randomElement()!),
            .init(title: title.randomElement()!,
                  startDate: "2025.05.03".toDate()!.date,
                  endDate: "2025.05.22".toDate()!.date,
                  color: color.randomElement()!),
            .init(title: title.randomElement()!,
                  startDate: "2025.05.01".toDate()!.date,
                  endDate: "2025.05.03".toDate()!.date,
                  color: color.randomElement()!),
            .init(title: title.randomElement()!,
                  startDate: "2025.05.01".toDate()!.date,
                  endDate: "2025.05.02".toDate()!.date,
                  color: color.randomElement()!),
            .init(title: title.randomElement()!,
                  startDate: "2025.04.28".toDate()!.date,
                  endDate: "2025.05.02".toDate()!.date,
                  color: color.randomElement()!),
            .init(title: "te",
                  startDate: "2025-05-19".toDate()!.date,
                  endDate: "2025-05-21".toDate()!.date,
                  color: .systemPink),
        ]
        
        return events
    }
}

//
//  VECEventManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/5/25.
//
import UIKit
internal import SwiftDate

class VECEventManager {
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
        // 초기화
        var activeEvents: [(VECEvent, Int)] = []

        // 이벤트를 시작 날짜 기준으로 정렬
        let sortedEvents = events.sorted { $0.startDate < $1.startDate }

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

        // 정렬 및 위치 재계산된 이벤트로 교체
        events = updatedEvents
    }
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
                  endDate: "2025.05.05".toDate()!.date,
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
        ]
        
        return events
    }
}

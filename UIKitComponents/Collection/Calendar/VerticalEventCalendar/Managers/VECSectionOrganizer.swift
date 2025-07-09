//
//  VECSectionOrganizer.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/7/25.
//
internal import SwiftDate

struct VECSectionOrganizer {
    /// 이벤트를 섹션 안에 삽입합니다.
    /// - 이 Function은 Day안에 존재하는 이벤트를 모두 리셋하고 다시 넣습니다.
    /// - Parameters:
    ///   - events: 정렬되고, Section.Month에 의해서 분류된 이벤트입니다.
    ///   - section: 다시 반환될 섹션입니다.
    func applyEventsOnEachDayWithStartingToDeleteEvents(events: [VECEvent], section: VECSection) -> VECSection {
        var section = section
        for (index, day) in section.days.enumerated() {
            var newDay = day
            
            newDay.events = [nil, nil, nil, nil]
            for event in events {
                if event.isDateBetweenStartAndEndDate(newDay.date) {
                    if event.locationNumber > 3 {
                        newDay.isMoreThanFourEvents = true
                        continue
                    } else {
                        newDay.events[event.locationNumber] = event
                        continue
                    }
                }
            }
            
            section.days[index] = newDay
        }
        
        
        return inspectEventsReorderByWeek(in: section)
    }
    
    func inspectEventsReorderByWeek(in section: VECSection) -> VECSection {
        var newSection = section
        var activeEvents: [UUID: Int] = [:]
        newSection.days = section.days.map { day in
            var newDay = day
            var newEvents = newDay.events
            
            if newDay.date.compare(.isSameDay(section.month.date.dateAt(.startOfMonth))) || newDay.date.weekday == 1 {
                newEvents = newEvents
                    .compactMap { $0 }
                    .sorted { $0.startDate < $1.startDate }
                    .enumerated()
                    .map {
                        var event = $0.element
                        event.locationNumber = $0.offset
                        activeEvents[event.id] = $0.offset
                        return event
                    }
            
            } else {
                newEvents
                    .compactMap {$0}
                    .enumerated()
                    .forEach { (index, event) in
                        var event = event
                        if let activeID = activeEvents[event.id], activeID != event.locationNumber {
                            var replaceEvent = newEvents[activeID]
                            replaceEvent?.locationNumber = event.locationNumber
                            newEvents[event.locationNumber] = replaceEvent
                            event.locationNumber = activeID
                            newEvents[activeID] = event
                            
                        }
                    }
            }
            
            newDay.events = newEvents
            
            return newDay
        }
        
        return newSection
    }
    
    /// 이벤트들을 구분한여 섹션 안 Days에 알맞게 넣습니다.
    /// - Parameters:
    ///   - events: 정렬되고, Section.Month에 의해서 분류된 이벤트입니다.
    ///   - section: 다시 반환될 섹션입니다.
    func applyEventsOnEachDay(events: [VECEvent], section: VECSection) -> VECSection {
        var section = section
        for (index, day) in section.days.enumerated() {
            var newDay = day
            for event in events {
                if event.isDateBetweenStartAndEndDate(newDay.date) {
                    if event.locationNumber > 3 {
                        newDay.isMoreThanFourEvents = true
                    } else {
//                        newDay.events.append(event)
                        newDay.events[event.locationNumber] = event
                    }
                }
            }
            
            section.days[index] = newDay
        }
        return inspectEventsReorderByWeek(in: section)
    }
    
    func applyEventsOnEachSection(events: [VECEvent], sections: [VECSection]) -> [VECSection] {
        var result: [VECSection] = []
        for section in sections {
            result.append(applyEventsOnEachDay(events: events, section: section))
        }
        return result
    }
    
    /// 이벤트 Date와 같은 달인 Section들을 반환합니다.
    private func findSectionsContainEventDate(
        _ event: VECEvent, sections: [VECSection]
    ) -> [VECSection] {
        return sections.filter {
            $0.month.date.compare(.isSameMonth(event.startDate))
            || $0.month.date.compare(.isSameMonth(event.endDate))
        }
    }
    
    /// Sections 안에 존재하는 Days와 Days Index를 반환하는 함수입니다.
    /// - event안 startDate와 endDate에 속한 Days를 필수로 반환합니다.
    /// - Parameters:
    ///   - event: 섹션을 구별하기 위한 이벤트
    ///   - isAdditionalEvent: true라면, 이벤트의 startDate와 endDate에 속해있는 Day에 이벤트를 구별하여 추가적으로 Days를 더 불러옵니다. 예를 들어 event endDate에 다른 이벤트가 존재하고, 존재하는 다른 이벤트가 파라미터 이벤트 Date에 속해 있지 않아도 Day를 불러옵니다.
    private func findDaysAndIndexRelativeToEventDateFromSections(
        _ event: VECEvent, sections: [VECSection],
        isAdditionalEvent: Bool = false
    ) -> [(VECDay, IndexPath)] {
        var result = [(VECDay, IndexPath)]()
        for (sectionIndex, section) in sections.enumerated() {
            // 섹션 month.date의 달이 이벤트의 startDate 또는 endDate에 달과 같지 않다면, 다음 섹션으로 넘어갑니다.
            guard
                event.startDate.compare(.isSameMonth(section.month.date))
                    || event.endDate.compare(.isSameMonth(section.month.date))
            else { continue }
            
            for (dayIndex, day) in section.days.enumerated() {
                // 이벤트의 startDate와 endDate사이에 day.date가 존재한다면.
                guard
                    day.date.isInRange(
                        date: event.startOfDay, and: event.endOfDay)
                else { continue }
                
                putAdditionalDaysIntoResult(
                    isAdditionalEvent, event, day, sections, &result)
                
                let indexPath = IndexPath(item: dayIndex, section: sectionIndex)
                result.append((day, indexPath))
                
            }
        }
        
        return result
    }
    /// findDaysAndIndexRelativeToEventDateFromSections기능을 도와주는 Function입니다. isAdditionalEvent를 받아 따로 처리하여 코드를 읽기 편하게 합니다.
    /// 기능의 목적은 sections에 Day를 이벤트 startDate와 endDate마다 구별하고, 이벤트 startDate 이후를 제외한 모든 Days 또는 endDate 이전을 제외한 모든 Days를 IndexPath와 함께 result에 추가합니다.
    fileprivate func putAdditionalDaysIntoResult(
        _ isAdditionalEvent: Bool, _ event: VECEvent, _ day: VECDay,
        _ sections: [VECSection], _ result: inout [(VECDay, IndexPath)]
    ) {
        // 기능 주석 참고
        guard isAdditionalEvent, event.locationNumber > 0 else { return }
        
        // 이벤트 startDate와 day.date가 같은 날이라면.
        if event.startDate.compare(.isSameDay(day.date)) {
            // 이벤트 중 startDate 가장 작은(가장 빠른 날짜.) 날짜를 할당합니다.
            if let fastestEvent = day.earliestEventByStartDate() {
                let dayAndIndexes =
                findDaysAndIndexRelativeToEventDateFromSections(
                    fastestEvent, sections: sections,
                    isAdditionalEvent: false)
                let newDAI = dayAndIndexes.filter {
                    $0.0.date < day.date.dateAt(.startOfDay)
                }
                if result.isEmpty {
                    newDAI.forEach { (day, indexPath) in
                        result.append((day, indexPath))
                    }
                } else {
                    var index = 0
                    newDAI.forEach { (day, indexPath) in
                        result.insert((day, indexPath), at: index)
                        index += 1
                    }
                }
            }
            return
        }
        
        // 이벤트 endDate와 day.date가 같은 날
        if event.endDate.compare(.isSameDay(day.date)) {
            if let latestEvent = day.latestEventByEndDate() {
                let dayAndIndexes =
                findDaysAndIndexRelativeToEventDateFromSections(
                    latestEvent, sections: sections,
                    isAdditionalEvent: false)
                let newDAI = dayAndIndexes.filter {
                    $0.0.date > day.date.dateAt(.endOfDay)
                }
                newDAI.forEach { (day, indexPath) in
                    result.append((day, indexPath))
                }
            }
            return
        }
    }
    
    /// 파
    
}

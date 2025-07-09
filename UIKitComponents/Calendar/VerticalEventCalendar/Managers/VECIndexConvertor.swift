//
//  VECInsexConvertor.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/25/25.
//
import DSA
internal import SwiftDate

struct VECIndexConvertor {
    func lastSectionIntoIndexSetAndPath(calendars: LinkedList<VECSection>) throws -> VECSectionIndex {
        let lastIndexInCalendars = calendars.count - 1
        
        let lastSection = calendars[lastIndexInCalendars]
        
        var sectionIndex = IndexSet()
        sectionIndex.insert(lastIndexInCalendars)
        let indexPaths = (0..<lastSection.days.count).map { IndexPath(item: $0, section: lastIndexInCalendars) }
        
        return VECSectionIndex(sectionIndex: sectionIndex,
                               dayIndex: indexPaths)
    }
    
    func firstSectionIntoIndexSetAndPath(calendars: LinkedList<VECSection>) throws -> VECSectionIndex {
        guard let firstSection = calendars.first else { throw VECError.noDataFromIndexPath }
        
        let sectionIndex = IndexSet(integer: 0)
        let indexPaths = (0..<firstSection.days.count).map { IndexPath(item: $0, section: 0) }
        
        return VECSectionIndex(sectionIndex: sectionIndex,
                               dayIndex: indexPaths)
    }
    
    func lastSectionIntoIndexSet(calendars: LinkedList<VECSection>) throws -> IndexSet {
        let lastIndexInCalendars = calendars.count - 1
        guard lastIndexInCalendars != -1 else { throw VECError.noDataFromIndexPath }
        return IndexSet(integer: lastIndexInCalendars)
    }
    
    func firstSectionIntoIndexSet(calendars: LinkedList<VECSection>) throws -> IndexSet {
        guard !calendars.isEmpty else { throw VECError.noDataFromIndexPath }
        return IndexSet(integer: 0)
    }
    
    func todayIndexPath(in calendars: LinkedList<VECSection>, date: Date = Date()) -> IndexPath? {
        let index = calendars
            .map { $0.month }
            .map { $0.date }
            .firstIndex { $0.year == date.year && $0.month == date.month }
            .map { index -> Int in
                return Int(index)
            }
        
        guard let index, index != 0 else { return nil }
        let dayIndex = calendars[index - 1]
        
        let indexPath = IndexPath(row: dayIndex.days.count - 1, section: index)
        
        return indexPath
    }
}


// MARK: - 이벤트에 관련된 IndexPath
extension VECIndexConvertor {
    func indexPathForEvent(startDate: Date, endDate: Date, in calendars: LinkedList<VECSection>) -> [IndexPath] {
        var result: [IndexPath] = []
        var breakTheLoop: Bool = false
        var leftEventIndexExsisted: Bool = false
        var leftEventIndexAfterMainEvent: Int = 0
        
        let startDate = startDate.dateAt(.startOfDay)
        let endDate = endDate.dateAt(.endOfDay)
        
        for (calendarIndex, calendar) in calendars.enumerated() {
            for (dayIndex, day) in calendar.days.enumerated() {
                if leftEventIndexAfterMainEvent != 0 {
                    leftEventIndexExsisted = true
                    leftEventIndexAfterMainEvent -= 1
                    result.append(IndexPath(item: dayIndex, section: calendarIndex))
                    continue
                }
                
                guard !breakTheLoop, !leftEventIndexExsisted else { break }
                // Day가 사용되지 않는 빈 Day거나, 이벤트 날짜 안에 속해 있지 않는 다면 다음 Day로 넘어감니다.
                guard !day.isEmptyDate else { continue }
                guard day.date >= startDate && day.date <= endDate else { continue }
                
                result.append(IndexPath(item: dayIndex, section: calendarIndex))
                
                
                
                if day.date.compare(.isSameDay(endDate)) {
                    var decideToBreak: Bool = false
                    for event in day.events {
                        guard let event else { continue }
                        guard let difference = day.date.difference(in: .day, from: event.endDate), difference != 0 else { continue }
                        
                        if difference > leftEventIndexAfterMainEvent {
                            leftEventIndexAfterMainEvent = difference
                            continue
                        }
                    }
                    
                    decideToBreak = leftEventIndexAfterMainEvent == 0 ? true : false
                    
                    // 마지막 날을 찾았으니, 루프를 멈춥니다.
                    if decideToBreak {
                        breakTheLoop = true
                        break
                    }
                }
            }
            
            if breakTheLoop { break }
        }
        return result
    }
}

//
//  VECInsexConvertor.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/25/25.
//
import DSA
internal import SwiftDate

struct VECIndexConvertor {
    func lastSectionIntoIndexSetAndPath(calendars: [VECSection]) throws -> VECSectionIndex {
        let lastIndexInCalendars = calendars.count - 1
        
        let lastSection = calendars[lastIndexInCalendars]
        
        var sectionIndex = IndexSet()
        sectionIndex.insert(lastIndexInCalendars)
        let indexPaths = (0..<lastSection.days.count).map { IndexPath(item: $0, section: lastIndexInCalendars) }
        
        return VECSectionIndex(sectionIndex: sectionIndex,
                               dayIndex: indexPaths)
    }
    
    func lastSectionIntoIndexSet(calendars: [VECSection]) throws -> IndexSet {
        let lastIndexInCalendars = calendars.count - 1
        guard lastIndexInCalendars != -1 else { throw VECError.noDataFromIndexPath }
        return IndexSet(integer: lastIndexInCalendars)
    }
    
    
    func getMonthIndexPath(in calendars: [VECSection], by date: Date = Date(), setLastWeekOfPrevMonth: Bool = true) -> IndexPath? {
        var indexPath: IndexPath
        let index = calendars
            .map { $0.month }
            .map { $0.date }
            .firstIndex { $0.year == date.year && $0.month == date.month }
            .map { index -> Int in
                return Int(index)
            }
        
        guard let index, index >= 0 else { return nil }
        let dayIndex = calendars[index - 1]
        
        if setLastWeekOfPrevMonth {
            indexPath = IndexPath(row: dayIndex.days.count - 1, section: index - 1)
        } else {
            indexPath = IndexPath(row: 0, section: index)
        }
        
        return indexPath
    }
    
    func getIndexPath(in calendars: [VECSection], by date: Date = Date(), setLastWeekOfDate: Bool = true) -> IndexPath? {
        var indexPath: IndexPath
        let monthIndex = findSectionIndex(by: date, calendars)
        let dayIndex = findCellIndex(by: date, calendars[monthIndex])
        
        guard monthIndex < 0, dayIndex < 0 else { return nil }
        
        if setLastWeekOfDate {
            if dayIndex < 7 {
                let lastMonth = calendars[monthIndex - 1]
                indexPath = IndexPath(item: lastMonth.days.count - 1, section: monthIndex - 1)
            } else {
                indexPath = IndexPath(item: dayIndex - 7, section: monthIndex)
            }
        } else {
            indexPath = IndexPath(item: dayIndex, section: monthIndex)
        }
        
        return indexPath
    }
    
    private func findSectionIndex(by date: Date, _ calendars: [VECSection]) -> Int {
        let index = calendars.firstIndex { section in
            let sectionDate = section.month.date
            return sectionDate.year == date.year && sectionDate.month == date.month
        }.map { Int($0) }
        guard let index, index >= 0 else { return 0 }
        return index
    }
    
    private func findCellIndex(by date: Date, _ calendar: VECSection) -> Int {
        let index = calendar.days.firstIndex { day in
            day.date.compare(.isSameDay(date))
        }
        guard let index, index >= 0 else { return 0 }
        return index
    }
}


// MARK: - 이벤트에 관련된 IndexPath
extension VECIndexConvertor {
    func indexSetForEvent(startDate: Date, endDate: Date, in calendars: [VECSection]) -> [IndexSet] {
        var result: [IndexSet] = []
        for (index, calendar) in calendars.enumerated() {
            if calendar.month.date.compare(.isSameMonth(startDate)) {
                result.append(IndexSet(integer: index))
            }
            
            if calendar.month.date.compare(.isSameMonth(endDate)) {
                result.append(IndexSet(integer: index))
            }
        }
        
        return result
    }
    
    
    /// 시작 날짜와 끝 날짜에 캘린더의 인덱스를 반환합니다.
    /// - Parameters:
    ///   - startDate:
    ///   - endDate:
    ///   - calendars: 반환될 인덱스의 기본값인 캘린더입니다. 캘린더의 Month는 Section에 해당되고, Days는 Item에 해당됩니다.
    func indexPathInBetween(from startDate: Date, to endDate: Date, in calendars: [VECSection]) -> [IndexPath] {
        var result: [IndexPath] = []
        var breakTheLoop: Bool = false
        var isAddingIndexPath: Bool = false
        
        let startDate = startDate.dateAt(.startOfDay)
        let endDate = endDate.dateAt(.endOfDay)
        
        for (calendarIndex, calendar) in calendars.enumerated() {
            guard calendar.month.date.compare(.isSameMonth(startDate)) || calendar.month.date.compare(.isSameMonth(endDate)) else {
                continue
            }
            
            for (dayIndex, day) in calendar.days.enumerated() {
                if day.date.compare(.isSameDay(startDate)) {
                    isAddingIndexPath = true
                    result.append(IndexPath(item: dayIndex, section: calendarIndex))
                    guard !day.date.compare(.isSameDay(endDate)) else {
                        breakTheLoop = true
                        break
                    }
                    continue
                } else if day.date.compare(.isSameDay(endDate)) {
                    result.append(IndexPath(item: dayIndex, section: calendarIndex))
                    isAddingIndexPath = false
                    breakTheLoop = true
                    break
                } else if isAddingIndexPath {
                    result.append(IndexPath(item: dayIndex, section: calendarIndex))
                    continue
                }
                
                
                
                
//                if leftEventIndexAfterMainEvent != 0 {
//                    leftEventIndexExsisted = true
//                    leftEventIndexAfterMainEvent -= 1
//                    result.append(IndexPath(item: dayIndex, section: calendarIndex))
//                    continue
//                }
//                
//                guard !breakTheLoop, !leftEventIndexExsisted else { break }
//                // Day가 사용되지 않는 빈 Day거나, 이벤트 날짜 안에 속해 있지 않는 다면 다음 Day로 넘어감니다.
//                guard !day.isEmptyDate else { continue }
//                guard day.date >= startDate && day.date <= endDate else { continue }
//                
//                result.append(IndexPath(item: dayIndex, section: calendarIndex))
//                
//                
//                
//                if day.date.compare(.isSameDay(endDate)) {
//                    var decideToBreak: Bool = false
//                    for event in day.events {
//                        guard let event else { continue }
//                        guard let difference = day.date.difference(in: .day, from: event.endDate), difference != 0 else { continue }
//                        
//                        if difference > leftEventIndexAfterMainEvent {
//                            leftEventIndexAfterMainEvent = difference
//                            continue
//                        }
//                    }
//                    
//                    decideToBreak = leftEventIndexAfterMainEvent == 0 ? true : false
//                    
//                    // 마지막 날을 찾았으니, 루프를 멈춥니다.
//                    if decideToBreak {
//                        breakTheLoop = true
//                        break
//                    }
//                }
            }
            
            if breakTheLoop { break }
        }
        return result
    }
}

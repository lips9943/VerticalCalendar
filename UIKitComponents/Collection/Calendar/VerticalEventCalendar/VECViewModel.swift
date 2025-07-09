//
//  VECViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import DSA
import UIKit
internal import SwiftDate

class VECViewModel {
    private let dateCreator = VECCalendarCreator()
    private let scrollCalculator = VECScrollCalculator()
    private let indexConvertor = VECIndexConvertor()
    private let eventManager = VECEventManager()
    private let sectionOrganizer = VECSectionOrganizer()
    
    private var startDate: Date!
    
    private var isActivateInfiniteScroll: Bool = false
    private var infiniteScrollCalendarsCount: Int = 100
    
    private var isEditing: Bool = false
    
    var calendars: [VECSection] = []
    var events: [VECEvent] = []
    
    init(startDate: Date) {
        self.startDate = startDate
        let now = Date.now
        var newCalendars: [VECSection] = .init()
        let difference = startDate.difference(in: .month, from: now) ?? 10
        var currentDate = startDate
        for _ in 0..<difference + 3 {
            newCalendars.append(dateCreator.generateCalendarByDate(currentDate))
            currentDate = currentDate.dateAt(.nextMonth)
        }
        

        var newEvents = eventManager.test()
        
        eventManager.calculateEventLayoutPositions(events: &newEvents)
        events = newEvents
        
        for (index, calendar) in newCalendars.enumerated() {
            let filteredEvent = eventManager.findEventsAtMonth(events, month: calendar.month.date)
            let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: filteredEvent, section: calendar)
            newCalendars[index] = newCalendar
        }
        
        calendars = newCalendars
    }
    
}

// MARK: - Scrolling
extension VECViewModel {
    func findTodaysIndexPath() -> IndexPath? {
        return indexConvertor.todayIndexPath(in: calendars)
    }
    
    func activateBottomInfiniteScroll(positionData: VECPositions) -> IndexSet? {
        isActivateInfiniteScroll = true
        var calendars = self.calendars
        guard scrollCalculator.isOffsetYAtBottomEdge(positionData: positionData) else {
            return nil
        }
        appendCalendar(&calendars)
        guard let mainIndex = try? indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return nil }
        self.calendars = calendars
        return mainIndex
    }
}

// MARK: - CRUD For Calendars
extension VECViewModel {
    private func appendCalendar(_ calendars: inout [VECSection]) {
        let section = dateCreator.generateCalendarByDate(calendars[calendars.count - 1].month.date.dateAt(.nextMonth))
        let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.append(newCalendar)
    }
    
    private func appendCalendar() {
        let section = dateCreator.generateCalendarByDate(calendars[calendars.count - 1].month.date.dateAt(.nextMonth))
        let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.append(newCalendar)
    }
}

// MARK: - Event Functions
extension VECViewModel {
    func addEvent(event: Event, collectionView: UICollectionView) {
        guard !isEditing else { return }
        isEditing = true
        // 변수에 할당된 이벤트들에 현재 만든 이벤트를 Append합니다.
        let vecEvent = VECEvent(event: event)
        var newEvents = events
        newEvents.append(vecEvent)
        
        // newEvents의 Location과 위치를 재설정합니다.
        eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        // 현재 이벤트를 Section안에 넣습니다. 그 과정에 Location에 맞게 이벤트를 재배치하여 올바르게 할당합니다.
        var newCalendars = calendars
        for (index, calendar) in newCalendars.enumerated() {
            let filteredEvent = eventManager.findEventsAtMonth(newEvents, month: calendar.month.date)
            newCalendars[index] = sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: filteredEvent, section: calendar)
        }
        
        // viewModel 안 events와 calendars에 NewEvents와 newCalendars를 할당합니다.
        events = newEvents
        calendars = newCalendars
        
        
        // 모든게 완료된 calendars를 이용해 CollectionView의 IndexPath를 가져와 reload합니다.
        let indexPaths = indexConvertor.indexPathInBetween(from: vecEvent.startDate,
                                                          to: vecEvent.endDate,
                                                          in: newCalendars)
        collectionView.reloadItems(at: indexPaths)
        isEditing = false
    }
    
    func deleteEvent(id: UUID) -> [IndexPath]? {
        // id에 해당되는 이벤트를 지우고, Location과 순서를 재설정합니다.
        var newEvents = events
        let eventIndex = newEvents.firstIndex { $0.id == id }
        guard let eventIndex else { return nil }
        let event = newEvents.remove(at: eventIndex)
        eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        var newCalendars: [VECSection: Int] = [:]
        calendars.enumerated().forEach {
            let currentMonth = $0.element.month.date
            let isTheSameMonthAtStartOrEndDate = currentMonth.compare(.isSameMonth(event.startDate)) || currentMonth.compare(.isSameMonth(event.endDate))
            if isTheSameMonthAtStartOrEndDate {
                newCalendars[$0.element] = $0.offset
            }
        }
        
        for calendar in newCalendars {
            let filteredEvent = eventManager.findEventsAtMonth(newEvents, month: calendar.key.month.date)
            calendars[calendar.value] = sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: filteredEvent, section: calendar.key)
        }
        
        events = newEvents
        
        
        // 모든게 완료된 calendars를 이용해 CollectionView의 IndexPath를 가져와 reload합니다.
        let indexPaths = indexConvertor.indexPathInBetween(from: event.startDate,
                                                          to: event.endDate,
                                                          in: calendars)
        
        return indexPaths
    }
}

extension VECViewModel {
    func deactivate(after time: Double = 1) {
        if isActivateInfiniteScroll {
            DispatchQueue.global().asyncAfter(deadline: .now() + time) { [weak self] in
                self?.isActivateInfiniteScroll = false
            }
        }
    }
}



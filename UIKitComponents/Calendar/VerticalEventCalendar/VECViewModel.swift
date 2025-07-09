//
//  VECViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import DSA
import UIKit

class VECViewModel {
    private let dateCreator = VECCalendarCreator()
    private let scrollCalculator = VECScrollCalculator()
    private let indexConvertor = VECIndexConvertor()
    private let eventManager = VECEventManager()
    private let sectionOrganizer = VECSectionOrganizer()
    
    private var startDate: Date!
    
    private var isActivateInfiniteScroll: Bool = false
    
    var calendars = LinkedList<VECSection>()
    var events: [VECEvent] = []
    
    init(startDate: Date = Date.now) {
        self.startDate = startDate
        let newCalendars: LinkedList<VECSection> = .init()
        newCalendars.append(dateCreator.generateCalendarByDate(startDate))
        let prependCalendars = dateCreator.prependCalendarsByDate(startDate, calendarCount: 5)
        var prependIndex = 0
        for pC in prependCalendars {
            newCalendars.insert(pC, at: prependIndex)
            prependIndex += 1
        }
        let appendCalendars = dateCreator.appendCalendarsByDate(startDate, calendarCount: 6)
        for aC in appendCalendars {
            newCalendars.append(aC)
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
    func addCalendarWithSectionsIndex(_ direction: VECScrollCalculator.Direction, calendars: inout LinkedList<VECSection>) -> IndexSet? {
        isActivateInfiniteScroll = true
        switch direction {
        case .top:
            prependAtFirst(&calendars)
            guard let mainIndex = try? indexConvertor.firstSectionIntoIndexSet(calendars: calendars) else { return nil }
            return mainIndex
            
        case .bottom:
            appendAtLast(&calendars)
            guard let mainIndex = try? indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return nil }
            return mainIndex
        }
    }
    func removeCalendarWithSectionsIndex(_ direction: VECScrollCalculator.Direction, calendars: inout LinkedList<VECSection>) -> IndexSet? {
        isActivateInfiniteScroll = true
        switch direction {
        case .top:
            guard let mainIndex = try? indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return nil }
            removeLast(&calendars)
            return mainIndex
            
        case .bottom:
            guard let mainIndex = try? indexConvertor.firstSectionIntoIndexSet(calendars: calendars) else { return nil }
            removeFirst(&calendars)
            return mainIndex
        }
    }
}

// MARK: - Scrolling
extension VECViewModel {
    /// offset이 특정 위치에 닿으면, 데이터를 추가하기 위한 Direction과 데이터가 추가 되었을 때, 특정 Section의 Height의 Delta를 반환합니다.
    func activateInfiniteScroll(collectionView: UICollectionView) -> VECScrollCalculator.Direction? {
        guard !isActivateInfiniteScroll else { return nil }
        guard let direction = scrollCalculator.calculateDirection(collectionView) else { return nil }
        
        return direction
    }
    
    /// contentOffset Y 포지션을 알맞는 자리에 위치시킵니다.
    func resetScroll(collectionView: UICollectionView,  calendars: LinkedList<VECSection>) -> CGFloat {
        let mainOffsetY = scrollCalculator.calculateOffsetAfterAddingData(
            collectionView: collectionView,
            calendars: calendars
        )
        return mainOffsetY
    }
    
    /// startDate에 맞춘
    func resetScroll() -> IndexPath? {
        guard let indexPath = indexConvertor.todayIndexPath(in: calendars) else { return nil }
        return indexPath
    }
}

// MARK: - CRUD For Calendars
extension VECViewModel {
    private func appendAtLast(_ calendars: inout LinkedList<VECSection>) {
        let section = dateCreator.generateCalendarByDate(calendars[calendars.count - 1].month.date.dateAt(.nextMonth))
        let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.append(newCalendar)
    }
    
    private func appendAtLast() {
        let section = dateCreator.generateCalendarByDate(calendars[calendars.count - 1].month.date.dateAt(.nextMonth))
        let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.append(newCalendar)
    }
    
    private func prependAtFirst(_ calendars: inout LinkedList<VECSection>) {
        let section = dateCreator.generateCalendarByDate(calendars[0].month.date.dateAt(.prevMonth))
        let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.insert(newCalendar, at: 0)
    }
    
    private func prependAtFirst() {
        let section = dateCreator.generateCalendarByDate(calendars[0].month.date.dateAt(.prevMonth))
        let newCalendar = sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.insert(newCalendar, at: 0)
    }
    
    private func removeFirst(_ calendars: inout LinkedList<VECSection>) {
        calendars.remove(at: 0)
    }
    
    private func removeFirst() {
        calendars.remove(at: 0)
    }
    
    private func removeLast(_ calendars: inout LinkedList<VECSection>) {
        calendars.removeLast()
    }
    
    private func removeLast() {
        calendars.removeLast()
    }
}

// MARK: - Event Functions
extension VECViewModel {
    func addEvent(event: Event, collectionView: UICollectionView) {
        // 변수에 할당된 이벤트들에 현재 만든 이벤트를 Append합니다.
        let vecEvent = VECEvent(event: event)
        var newEvents = events
        newEvents.append(vecEvent)
        
        // newEvents의 Location과 위치를 재설정합니다.
        eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        // 현재 이벤트를 Section안에 넣습니다. 그 과정에 Location에 맞게 이벤트를 재배치하여 올바르게 할당합니다.
        let newCalendars = calendars
        for (index, calendar) in newCalendars.enumerated() {
            let filteredEvent = eventManager.findEventsAtMonth(newEvents, month: calendar.month.date)
            newCalendars[index] = sectionOrganizer.applyEventsOnEachDayFromStartToDeleteEvents(events: filteredEvent, section: calendar)
        }
        
        // viewModel 안 events와 calendars에 NewEvents와 newCalendars를 할당합니다.
        events = newEvents
        calendars = newCalendars
        
        
        // 모든게 완료된 calendars를 이용해 CollectionView의 IndexPath를 가져와 reload합니다.
        let indexPaths = indexConvertor.indexPathForEvent(startDate: vecEvent.startDate,
                                                          endDate: vecEvent.endDate,
                                                          in: newCalendars)
        collectionView.reloadItems(at: indexPaths)
    }
    
    func deleteEvent(id: UUID, collectionView: UICollectionView) {
        // id에 해당되는 이벤트를 지우고, Location과 순서를 재설정합니다.
        var newEvents = events
        let eventIndex = newEvents.firstIndex { $0.id == id }
        guard let eventIndex else { return }
        let event = newEvents.remove(at: eventIndex)
        eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        let newCalendars = calendars
        for (index, calendar) in newCalendars.enumerated() {
            let filteredEvent = eventManager.findEventsAtMonth(newEvents, month: calendar.month.date)
            newCalendars[index] = sectionOrganizer.applyEventsOnEachDayFromStartToDeleteEvents(events: filteredEvent, section: calendar)
        }
        
        events = newEvents
        calendars = newCalendars
        
        // 모든게 완료된 calendars를 이용해 CollectionView의 IndexPath를 가져와 reload합니다.
        let indexPaths = indexConvertor.indexPathForEvent(startDate: event.startDate,
                                                          endDate: event.endDate,
                                                          in: newCalendars)
        collectionView.reloadItems(at: indexPaths)
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



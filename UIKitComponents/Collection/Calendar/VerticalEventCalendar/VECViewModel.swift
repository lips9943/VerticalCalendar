//
//  VECViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import DSA
import UIKit
internal import SwiftDate

class VECViewModel: @unchecked Sendable {
    private let dateCreator = VECCalendarCreator()
    private let scrollCalculator = VECScrollCalculator()
    private let indexConvertor = VECIndexConvertor()
    private let eventManager = VECEventManager()
    private let sectionOrganizer = VECSectionOrganizer()
    private let collectionView: UICollectionView
    private var startDate: Date!
    
    private var isActivateInfiniteScroll: Bool = false
    private var infiniteScrollCalendarsCount: Int = 100
    
    private var isEditing: Bool = false
    
    var calendars: [VECSection] = []
    var events: [VECEvent] = []
    
    init(collectionView: UICollectionView,
         startDate: Date) {
        self.collectionView = collectionView
        self.startDate = startDate
        Task {
            var newCalendars = await setDefaultCalendars(startDate: startDate)
            
            DispatchQueue.main.async {
                self.calendars = newCalendars
                collectionView.reloadData()
            }
        }
    }
    
    private func setDefaultCalendars(startDate: Date) async -> [VECSection] {
        let now = Date.now
        var newCalendars: [VECSection] = .init()
        let difference = startDate.difference(in: .month, from: now) ?? 10
        var currentDate = startDate
        for _ in 0..<difference + 3 {
            let calendar = await dateCreator.generateCalendarByDate(currentDate)
            newCalendars.append(calendar)
            currentDate = currentDate.dateAt(.nextMonth)
        }
        
        return newCalendars
    }
}

// MARK: - Scrolling
extension VECViewModel {
    func moveScrollToCurrentMonthSection(by date: Date, setPrev: Bool) async {
        guard let indexPath = await indexConvertor.getMonthIndexPath(in: calendars, by: date, setLastWeekOfPrevMonth: setPrev) else { return }
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
    }
    
    func moveScrollToCurrentDateCell(by date: Date, setPrev: Bool) async {
        guard let indexPath = await indexConvertor.getIndexPath(in: calendars, by: date, setLastWeekOfDate: setPrev) else { return }
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
    }
    
    func activateBottomInfiniteScroll(positionData: VECPositions) async -> IndexSet? {
        isActivateInfiniteScroll = true
        var calendars = self.calendars
        guard scrollCalculator.isOffsetYAtBottomEdge(positionData: positionData) else {
            return nil
        }
        await appendCalendar(&calendars)
        guard let mainIndex = try? await indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return nil }
        self.calendars = calendars
        return mainIndex
    }
}

// MARK: - CRUD For Calendars
extension VECViewModel {
    private func appendCalendar(_ calendars: inout [VECSection]) async {
        let section = await dateCreator.generateCalendarByDate(calendars[calendars.count - 1].month.date.dateAt(.nextMonth))
        let newCalendar = await sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        calendars.append(newCalendar)
    }
    
    private func appendCalendar() async {
        let section = await dateCreator.generateCalendarByDate(calendars[calendars.count - 1].month.date.dateAt(.nextMonth))
        let newCalendar = await sectionOrganizer.applyEventsOnEachDay(events: events, section: section)
        DispatchQueue.main.async {
            self.calendars.append(newCalendar)
        }
    }
}

// MARK: - Event Functions
extension VECViewModel {
    func add(event: Event) async {
        guard !isEditing else { return }
        isEditing = true
        // 변수에 할당된 이벤트들에 현재 만든 이벤트를 Append합니다.
        let vecEvent = VECEvent(event: event)
        var newEvents = events
        newEvents.append(vecEvent)
        
        // newEvents의 Location과 위치를 재설정합니다.
        await eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        // 현재 이벤트를 Section안에 넣습니다. 그 과정에 Location에 맞게 이벤트를 재배치하여 올바르게 할당합니다.
        var newCalendars = calendars
        for (index, calendar) in newCalendars.enumerated() {
            let filteredEvent = await eventManager.findEventsAtMonth(newEvents, month: calendar.month.date)
            newCalendars[index] = await sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: filteredEvent, section: calendar)
        }
        
        // 모든게 완료된 calendars를 이용해 CollectionView의 IndexPath를 가져와 reload합니다.
        let indexPaths = await indexConvertor.indexPathInBetween(from: vecEvent.startDate,
                                                          to: vecEvent.endDate,
                                                          in: newCalendars)
        
        // viewModel 안 events와 calendars에 NewEvents와 newCalendars를 할당합니다.
        DispatchQueue.main.async {
            self.events = newEvents
            self.calendars = newCalendars
            self.collectionView.reloadItems(at: indexPaths)
            self.isEditing = false
        }
    }
    
    func add(events: [Event]) async {
        guard !isEditing else { return }
        isEditing = true
        // 변수에 할당된 이벤트들에 현재 만든 이벤트를 Append합니다.
        var newEvents = self.events
        newEvents.append(contentsOf: events.map { VECEvent(event: $0)})
        
        // newEvents의 Location과 위치를 재설정합니다.
        await eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        var newCalendars = calendars
        for (index, calendar) in newCalendars.enumerated() {
            let filteredEvent = await eventManager.findEventsAtMonth(newEvents, month: calendar.month.date)
            newCalendars[index] = await sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: filteredEvent, section: calendar)
        }
        
        // viewModel 안 events와 calendars에 NewEvents와 newCalendars를 할당합니다.
        DispatchQueue.main.async {
            self.events = newEvents
            self.calendars = newCalendars
            self.collectionView.reloadData()
            self.isEditing = false
        }
    }
    
    func deleteEvent(by id: String) async -> [IndexPath]? {
        // id에 해당되는 이벤트를 지우고, Location과 순서를 재설정합니다.
        var newEvents = events
        let eventIndex = newEvents.firstIndex { $0.ekEventID == id }
        guard let eventIndex else { return nil }
        let event = newEvents.remove(at: eventIndex)
        await eventManager.calculateEventLayoutPositions(events: &newEvents)
        
        var newCalendars: [VECSection: Int] = [:]
        calendars.enumerated().forEach {
            let currentMonth = $0.element.month.date
            let isTheSameMonthAtStartOrEndDate = currentMonth.compare(.isSameMonth(event.startDate)) || currentMonth.compare(.isSameMonth(event.endDate))
            if isTheSameMonthAtStartOrEndDate {
                newCalendars[$0.element] = $0.offset
            }
        }
        
        for calendar in newCalendars {
            let filteredEvent = await eventManager.findEventsAtMonth(newEvents, month: calendar.key.month.date)
            calendars[calendar.value] = await sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: filteredEvent, section: calendar.key)
        }
        
        events = newEvents
        
        
        // 모든게 완료된 calendars를 이용해 CollectionView의 IndexPath를 가져와 reload합니다.
        let indexPaths = await indexConvertor.indexPathInBetween(from: event.startDate,
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



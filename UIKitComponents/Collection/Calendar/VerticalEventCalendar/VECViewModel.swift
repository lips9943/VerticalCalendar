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
    private var lastDateOfMonth: Date!
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
        let newCalendars = setDefaultCalendars(startDate: startDate)
        self.lastDateOfMonth = newCalendars.last!.month.date
        DispatchQueue.main.async {
            self.calendars = newCalendars
            collectionView.reloadData()
        }
    }
    
    private func setDefaultCalendars(startDate: Date) -> [VECSection] {
        let now = Date.now
        var newCalendars: [VECSection] = .init()
        let difference = startDate.difference(in: .month, from: now) ?? 10
        var currentDate = startDate
        for _ in 0..<difference + 3 {
            let calendar = dateCreator.generateCalendarByDate(currentDate)
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
        await UIView.setAnimationsEnabled(false)
        
        
        await self.collectionView.performBatchUpdates {
            var calendars = self.calendars
            guard scrollCalculator.isOffsetYAtBottomEdge(positionData: positionData) else { return }
            Task {
                let section = await appendCalendar(&calendars)
                guard let mainIndex = try? await indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return }
                self.calendars = calendars
                DispatchQueue.main.async {
                    self.collectionView.insertSections(mainIndex)
                }
                
                self.deactivate(after: 0.15)
                await UIView.setAnimationsEnabled(true)
                await put(events: self.events, in: section)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(mainIndex)
                }
                
            }
        }
//
//        var calendars = self.calendars
//        guard scrollCalculator.isOffsetYAtBottomEdge(positionData: positionData) else { return nil }
//        let section = await appendCalendar(&calendars)
//        guard let mainIndex = try? await indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return nil }
//        
//        Task {
//            await put(events: self.events, in: section)
//        }
//        return mainIndex
        return nil
    }
}

// MARK: - CRUD For Calendars
extension VECViewModel {
    private func appendCalendar(_ calendars: inout [VECSection]) async -> VECSection {
        if let lastDateofMonth = self.lastDateOfMonth?.dateAt(.nextMonth) {
            let section = await dateCreator.generateCalendarByDate(lastDateofMonth)
            calendars.append(section)
            self.lastDateOfMonth = lastDateofMonth
            return section
        } else {
            guard let lastDateofMonth = calendars.last?.month.date.dateAt(.nextMonth) else { fatalError("마지막 Date가 저장되어 있지 않습니다.") }
            let section = await dateCreator.generateCalendarByDate(lastDateofMonth)
            calendars.append(section)
            self.lastDateOfMonth = lastDateofMonth
            return section
        }
    }
}

// MARK: - Section Editing
extension VECViewModel {
    private func put(events: [VECEvent], in section: VECSection) async {
        var calendars = self.calendars
        var events = events
        await eventManager.calculateEventLayoutPositions(events: &events)
        let filteredEvents = await eventManager.filter(events: events, at: section.month.date)
        let newCalendar = await sectionOrganizer.applyEventsOnEachDay(events: filteredEvents, section: section)
        if let index = calendars.firstIndex(of: section) {
            calendars[index] = newCalendar
        } else {
            calendars.append(newCalendar)
        }
        self.calendars = calendars
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
            let filteredEvent = await eventManager.filter(events: newEvents, at: calendar.month.date)
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
            let filteredEvent = await eventManager.filter(events: newEvents, at: calendar.month.date)
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
            let filteredEvent = await eventManager.filter(events: newEvents, at: calendar.key.month.date)
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



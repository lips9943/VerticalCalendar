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
    var eventGroups: [VECEventGroup] = []
    
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
    
    func activateBottomInfiniteScroll(positionData: VECPositions) async {
        guard scrollCalculator.isOffsetYAtBottomEdge(positionData: positionData) else { return }
        guard !isActivateInfiniteScroll else { return }
        isActivateInfiniteScroll = true
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
        }
        
        await self.collectionView.performBatchUpdates {
            var calendars = self.calendars
            Task {
                let section = await appendCalendar(&calendars)
                guard let mainIndex = try? await indexConvertor.lastSectionIntoIndexSet(calendars: calendars) else { return }
                self.calendars = calendars
                DispatchQueue.main.async {
                    self.collectionView.insertSections(mainIndex)
                }
                
                await putEvents(on: self.lastDateOfMonth, in: section)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(mainIndex)
                    self.isActivateInfiniteScroll = false
                    print("end")
                    UIView.setAnimationsEnabled(true)
                }
                
            }
        }
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
    private func putEvents(on date: Date, in section: VECSection) async {
        var calendars = self.calendars
        guard let events = self.eventGroups.first(where: { $0 == date
        })?.events else { return }
        var arrayEvents = Array(events)
        
        await eventManager.calculateEventLayoutPositions(events: &arrayEvents)
        let newCalendar = await sectionOrganizer.applyEventsOnEachDay(events: arrayEvents, section: section)
        
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
    func addWithGroup(event: Event) async {
        guard !isEditing else { return }
        isEditing = true
        
        let vecEvent = VECEvent(event: event)
        let groups = await eventManager.add(event: vecEvent, in: &self.eventGroups)
        
        var calendars = self.calendars
        for group in groups {
            guard let index = calendars.firstIndex(where: { group == $0.month.date }) else { continue }
            
            var events = Array(group.events)
            await eventManager.calculateEventLayoutPositions(events: &events)
            
            calendars[index] = await sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: events, section: calendars[index])
        }
        
        let indexPaths = await indexConvertor.indexPathInBetween(from: vecEvent.startDate,
                                                          to: vecEvent.endDate,
                                                          in: calendars)
        
        // viewModel 안 events와 calendars에 NewEvents와 newCalendars를 할당합니다.
        DispatchQueue.main.async {
            self.calendars = calendars
            self.collectionView.reloadItems(at: indexPaths)
            self.isEditing = false
        }
    }
    
    func addWithGroup(events: [Event]) async {
        guard !isEditing else { return }
        isEditing = true
        
        // 변수에 할당된 이벤트들에 현재 만든 이벤트를 Append합니다.
        let groups = await eventManager.add(events: events.map { VECEvent(event: $0) }, in: &self.eventGroups)
        var calendars = self.calendars
        
        for group in groups {
            guard let index = calendars.firstIndex(where: { group == $0.month.date }) else { continue }
            
            var events = Array(group.events)
            await eventManager.calculateEventLayoutPositions(events: &events)
            
            calendars[index] = await sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: events, section: calendars[index])
        }
        
        // viewModel 안 events와 calendars에 NewEvents와 newCalendars를 할당합니다.
        DispatchQueue.main.async {
            self.calendars = calendars
            self.collectionView.reloadData()
            self.isEditing = false
        }
    }
    
    func deleteEvent(by id: String, between dates: [Date]) async {
        guard !isEditing else { return }
        isEditing = true
        var calendarWithIndex: [VECSection : Array<VECSection>.Index] = [:]
        let groups = await eventManager.delete(event: id, between: dates, in: &self.eventGroups)
        
        for group in groups {
            guard let index = calendars.firstIndex(where: { group == $0.month.date }) else { continue }
            var events = Array(group.events)
            await eventManager.calculateEventLayoutPositions(events: &events)
            let calendar = await sectionOrganizer.applyEventsOnEachDayWithStartingToDeleteEvents(events: events, section: calendars[index])
            calendarWithIndex[calendar] = index
        }
        
        let indexPaths = await indexConvertor.indexPathInBetween(from: dates.first!,
                                                                 to: dates.last!,
                                                                 in: calendars)
        
        DispatchQueue.main.async {
            for (calendar, index) in calendarWithIndex {
                self.calendars[index] = calendar
            }
            
            self.collectionView.reloadItems(at: indexPaths)
            self.isEditing = false
        }       
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



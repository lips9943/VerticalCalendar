//
//  VCTestViewModel.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import Combine
import UIKit

public class VCDefaultViewModel: VCViewModel {
    public var calendar: Calendar
    public var locale: Locale
    public var startDate: Date
    public var endData: Date
    public var calendarManager: VCDefaultCalendarManager
    public var indexManager: VCIndexingManager
    public var calendars: [VCDefaultCalendar]
    
    public init(calendarManager: VCDefaultCalendarManager) {
        self.calendarManager = calendarManager
        self.indexManager = .init(calendar: calendarManager.calendar)
        self.startDate = calendarManager.startDate
        self.endData = calendarManager.endDate
        self.calendar = calendarManager.calendar
        self.locale = calendarManager.locale
        let calendars = try? calendarManager.createCalendars()
        self.calendars = calendars ?? []
    }
}

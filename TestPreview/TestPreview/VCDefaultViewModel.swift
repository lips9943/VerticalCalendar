//
//  VCTestViewModel.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import Combine
import VerticalCalendar
import Foundation

class VCDefaultViewModel: VCViewModel {
    var calendar: Calendar
    var locale: Locale
    var startDate: Date
    var endData: Date
    var calendarManager: VCDefaultCalendarManager
    var indexManager: VCIndexingManager
    var calendars: [VCDefaultCalendar]
    
    init(calendarManager: VCDefaultCalendarManager) {
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

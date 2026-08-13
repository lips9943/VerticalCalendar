//
//  VCViewModel.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/25/25.
//
import Foundation
import Combine

public protocol VCViewModel: ObservableObject {
    associatedtype MainCalendar: VCCalendar
    associatedtype CalendarManager: VCCalendarManager
    var calendarManager: CalendarManager { get }
    var indexManager: VCIndexingManager { get }
    var calendars: [MainCalendar] { set get }
}

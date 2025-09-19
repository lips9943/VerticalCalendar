//
//  VCViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/25/25.
//
import Foundation
import Combine

public protocol VCViewModel: ObservableObject {
    associatedtype MainCalendar: VCCalendar
    associatedtype CalendarManager: VCCalendarManager
    var calendar: Calendar { get }
    var locale: Locale { get }
    var startDate: Date { get }
    var endData: Date { get }
    var calendarManager: CalendarManager { get }
    var indexManager: VCIndexingManager { get }
    var calendars: [MainCalendar] { set get }
}

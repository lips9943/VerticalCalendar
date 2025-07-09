//
//  Event.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/7/25.
//
import UIKit

public struct Event {
    public let id: String
    public var title: String
    public var startDate: Date
    public var endDate: Date
    public var calendar: String
    public var color: UIColor
    public var isAllDay: Bool
    
    public init(id: String, title: String, startDate: Date, endDate: Date, calendar: String, color: UIColor, isAllDay: Bool) {
        self.id = id
        self.title = title
        self.startDate = startDate.dateAt(.startOfDay)
        self.endDate = endDate.dateAt(.startOfDay)
        self.color = color
        self.isAllDay = isAllDay
        self.calendar = calendar
    }
    
    static func invert(_ event: VECEvent) -> Event {
        Event(id: event.ekEventID,
              title: event.title,
              startDate: event.startDate,
              endDate: event.endDate,
              calendar: event.calendar,
              color: event.color,
              isAllDay: event.isAllDay)
    }
    
    private func timeSetUp(date: Date) -> Date {
        return date.dateAt(.startOfDay)
    }
}

//
//  Event.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/7/25.
//
import UIKit

public struct Event {
    public let id: UUID
    public var title: String
    public var startDate: Date
    public var endDate: Date
    public var color: UIColor
    public var isAllDay: Bool
    
    static func invert(_ event: VECEvent) -> Event {
        Event(id: event.id,
              title: event.title,
              startDate: event.startDate,
              endDate: event.endDate,
              color: event.color,
              isAllDay: event.isAllDay)
    }
}

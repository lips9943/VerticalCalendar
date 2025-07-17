//
//  Date.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/17/25.
//
internal import SwiftDate

extension Date {
    // - TODO: 현재는 Month만 구현되어 있음.
    func range(of calendar: Calendar.Component, with date: Date) -> [Date] {
        var currentDate: Date = self
        var result: [Date] = []
        switch calendar {
        case .month:
            guard let count = self.difference(in: calendar, from: date) else { fatalError() }
            for _ in 0...count {
                result.append(currentDate)
                currentDate = currentDate.dateAt(.nextMonth)
            }
            return result
        @unknown default:
            fatalError()
        }
    }
}

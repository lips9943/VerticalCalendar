//
//  DateExtension.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//
import Foundation

extension Date {
    var year: Int? {
        let current = self.currentDate()
        return Int(current.year)
    }
    
    var month: Int? {
        let current = self.currentDate()
        return Int(current.month)
    }
    
    var day: Int? {
        let current = self.currentDate()
        return Int(current.day)
    }
    
    
    public func atFirstDayOfMonth(_ calendar: Calendar = .current) -> Date? {
        let components = calendar.dateComponents([.month, .year], from: self)
        let firstDay = calendar.date(from: .init(year: components.year, month: components.month, day: 1))
        return firstDay
    }
    
    func isSameDay(as other: Date) -> Bool {
        let current = self.currentDate()
        let otherDate = other.currentDate()
        return current.isSameDay(as: otherDate)
    }
    
    func isSameMonth(as other: Date) -> Bool {
        let current = self.currentDate()
        let otherDate = other.currentDate()
        return current.isSameMonth(as: otherDate)
    }
    
    fileprivate func currentDate() -> DateModel {
        let formatter = DateFormatter()

        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "MM/dd/yyyy"

        let dateString = formatter.string(from: self)

        let dates = dateString.split(separator: "/").compactMap { String($0) }
        let result = DateModel(year: dates[2], month: dates[0], day: dates[1])
        return result
    }
    
    fileprivate struct DateModel {
        fileprivate var year: String
        fileprivate var month: String
        fileprivate var day: String
        fileprivate init(year: String, month: String, day: String) {
            self.year = year
            self.month = month
            self.day = day
        }
        
        fileprivate func isSameDay(as other: Self) -> Bool {
            return self.day == other.day && self.month == other.month && self.year == other.year
        }
        
        fileprivate func isSameMonth(as other: Self) -> Bool {
            return self.month == other.month && self.year == other.year
        }
    }
}

//
//  HDSDateManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//
internal import SwiftDate

struct HDSDateManager {
    func generateDays(by date: Date = Date.now, between month: Int = 3) -> [Date] {
        var result = [Date]()
        var startDate = date - month.months
        let endDate = startDate + (month * 2).months
        
        while startDate <= endDate {
            result.append(startDate)
            startDate = startDate.dateAt(.tomorrow)
        }
        return result
    }
    
    
}

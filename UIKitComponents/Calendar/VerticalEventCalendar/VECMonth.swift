//
//  VECMonth.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

struct VECMonth {
    var date: Date
    
    init(date: Date) {
        self.date = date.dateAt(.startOfMonth)
    }
}

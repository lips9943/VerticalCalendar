//
//  VCDefaultCalendar.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//
import VerticalCalendar

final class VCDefaultCalendar: VCCalendar {
    var month: VCDefaultMonth
    var days: [VCDefaultDay]
    
    init(month: VCDefaultMonth, days: [VCDefaultDay]) {
        self.month = month
        self.days = days
    }
}

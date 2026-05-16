//
//  VCDefaultCalendar.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

public final class VCDefaultCalendar: VCCalendar {
    public var month: VCDefaultMonth
    public var days: [VCDefaultDay]
    
    public init(month: VCDefaultMonth, days: [VCDefaultDay]) {
        self.month = month
        self.days = days
    }
}

//
//  VCCalendar.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/2/25.
//


public final class VCDefalutCalendar: VCCalendar {
    public var month: VCDefalutMonth
    public var days: [VCDefalutDay]
    
    init(month: VCDefalutMonth, days: [VCDefalutDay]) {
        self.month = month
        self.days = days
    }
}

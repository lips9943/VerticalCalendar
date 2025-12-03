//
//  VCalendarBuilder.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/6/25.
//
#if DEBUG 
public class VCalendarBuilder {
    private var vm: VCDefalutViewModel!
    
    public typealias T = VCalendar
    
    public func setCalendarManager(_ calendarManager: VCDefaultCalendarManager) -> Self {
        return self
    }
    public func build() -> VCalendar {
        return .init(viewModel: self.vm)
    }
}
#endif

//
//  VCTestPreview.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/2/25.
//



#if DEBUG
import UIKit
class PreviewConfigure {
    var calendarVC: VCalendar = {
        let calendar = Calendar.current
        let date = Date()
        let startDate = calendar.date(byAdding: .init(year: -50), to: date)!
        let endDate = calendar.date(byAdding: .init(year: 50), to: date)!
        let cm = VCDefaultCalendarManager(startDate: startDate, endDate: endDate, calendar: calendar, locale: .current)
        let vm = VCDefalutViewModel(calendarManager: cm)
        let calendarVC = VCalendar(viewModel: vm)
        calendarVC.defaultRegisterSet()
        calendarVC.title = "Calendar"
        return calendarVC
    }()
    
    func configure() -> UINavigationController {
        let nc = UINavigationController(rootViewController: calendarVC)
        nc.navigationBar.prefersLargeTitles = false
        nc.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        nc.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        return nc
    }
}

import SwiftUI
@available(iOS 18.0, watchOS 11.0)
#Preview {
    // 애플와치 일 때
    #if os(iOS)
    PreviewConfigure().configure()
    #elseif os(watchOS)
    
    #endif
    
    
}

#endif



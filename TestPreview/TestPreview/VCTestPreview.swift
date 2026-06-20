//
//  VCTestPreview.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

#if DEBUG
import UIKit
import SwiftUI
import VerticalCalendar

struct VCTestPreview: UIViewControllerRepresentable {
    var cm: VCDefaultCalendarManager {
        let calendar = Calendar.current
        let date = Date()
        let startDate = calendar.date(byAdding: .init(year: -50), to: date)!
        let endDate = calendar.date(byAdding: .init(year: 50), to: date)!
        return VCDefaultCalendarManager(startDate: startDate, endDate: endDate, calendar: calendar, locale: .current)
    }
    
    var vm: VCDefaultViewModel { VCDefaultViewModel(calendarManager: cm) }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = VCalendar(viewModel: vm)
        vc.title = "Calendar"
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.prefersLargeTitles = false
        nc.navigationBar.titleTextAttributes = [.font : UIFont.preferredFont(forTextStyle: .title1)]
        nc.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        nc.navigationBar.topItem?.leftBarButtonItem = .init(systemItem: .organize, primaryAction: .init(handler: { action in
            vc.presentMonthSelectionVC()
        }))
        return nc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


@available(iOS 18.0, watchOS 11.0, *)
#Preview {
    #if os(iOS)
    VCTestPreview()
    #elseif os(watchOS)
    // Add watchOS preview if needed
    Text("Watch Preview")
    #endif   
}
#endif

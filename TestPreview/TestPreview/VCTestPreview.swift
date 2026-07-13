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
    @Binding var presentMonthSelectionVC: Bool
    @Binding var isLoading: Bool
    
    var cm: VCDefaultCalendarManager {
        let calendar = Calendar.current
        let date = Date()
        let startDate = calendar.date(byAdding: .init(year: -50), to: date)!
        let endDate = calendar.date(byAdding: .init(year: 50), to: date)!
        return VCDefaultCalendarManager(startDate: startDate, endDate: endDate, calendar: calendar, locale: .current)
    }
    
    var vm: VCDefaultViewModel { VCDefaultViewModel(calendarManager: cm) }
    
    func makeUIViewController(context: Context) -> some UINavigationController {
        let vc = VCalendar(viewModel: vm)
        vc.isLoading = isLoading
        vc.title = "Calendar"
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.prefersLargeTitles = false
        nc.navigationBar.titleTextAttributes = [.font : UIFont.preferredFont(forTextStyle: .title1)]
        nc.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        nc.navigationBar.topItem?.leftBarButtonItem = .init(systemItem: .organize, primaryAction: .init(handler: { action in
            vc.presentMonthSelectionVC(cellType: VCDefaultMonthSelectionCell.self)
        }))
        
        return nc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let vc = uiViewController.topViewController as? VCalendar else { return }
        if presentMonthSelectionVC {
            vc.presentMonthSelectionVC(cellType: VCDefaultMonthSelectionCell.self)
            presentMonthSelectionVC = false
        }
        
        vc.isLoading = isLoading
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: VCTestPreview
        
        init(_ parent: VCTestPreview) {
            self.parent = parent
        }
    }
}

//@available(iOS 18.0, watchOS 11.0, *)
#Preview {
    @Previewable @State var presentMonthSelectionVC: Bool = false
    @Previewable @State var isLoading: Bool = false
    #if os(iOS)
    VCTestPreview(presentMonthSelectionVC: $presentMonthSelectionVC, isLoading: $isLoading)
    #elseif os(watchOS)
    // Add watchOS preview if needed
    Text("Watch Preview")
    #endif   
}
#endif

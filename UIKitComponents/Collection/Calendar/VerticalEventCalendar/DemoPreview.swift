//
//  DemoPreview.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import SwiftUI
internal import SnapKit
internal import SwiftDate

#if DEBUG
#Preview(body: {
    VECTestViewController()
})

class VECTestViewController: UIViewController {
    let v = VEC(startDate: Date().dateAt(.prevYear),events: [])
    override func viewDidLoad() {
        self.v.setOffsetToCurrentDateCell()
        v.mainBGColor = .systemBackground
        v.weekdayTextColor = .label
        v.monthHeaderTextColor = .systemGray3
        v.topBorderColor = .systemGray3
        v.todayCellColor = .darkGray.withAlphaComponent(0.4)
        v.delegate = self
        self.view.addSubview(v)
        v.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        let testEraseUUID = UUID().uuidString
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.v.addEvent(event: Event(id: testEraseUUID, title: "진짜 테스트다", startDate: "2025-05-03".toDate()!.date, endDate: "2025-05-21".toDate()!.date, color: .systemPink, isAllDay: true))
//            self.v.addEvent(event: Event(id: .init(), title: "첫 날", startDate: "2025-05-21".toDate()!.date, endDate: "2025-05-21".toDate()!.date, color: .darkGray, isAllDay: true))
//            self.v.addEvent(event: Event(id: .init(), title: "첫 날", startDate: "2025-05-19".toDate()!.date, endDate: "2025-05-20".toDate()!.date, color: .darkGray, isAllDay: true))
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.v.deleteEvent(id: testEraseUUID)
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.v.scrollToCurrentIndexPath()
        }
    }
}

extension VECTestViewController: VECDelegate {
    func onEventTapped(event: Event) {
        print(event.title)
    }
}
#endif

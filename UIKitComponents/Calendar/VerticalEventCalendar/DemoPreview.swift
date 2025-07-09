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
    override func viewDidLoad() {
        let v = VEC()
        v.mainBGColor = .systemBackground
        v.weekdayTextColor = .label
        v.monthHeaderTextColor = .systemGray3
        v.cellBorderColor = .systemGray3
        v.delegate = self
        self.view.addSubview(v)
        v.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        let testEraseUUID = UUID()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            v.addEvent(event: Event(id: testEraseUUID, title: "진짜 테스트다", startDate: Date(), endDate: Date().dateAt(.nextWeek), color: .systemPink, isAllDay: true))
            v.addEvent(event: Event(id: .init(), title: "첫 날", startDate: Date(), endDate: Date(), color: .darkGray, isAllDay: true))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                v.deleteEvent(id: testEraseUUID)
            }
        }
    }
}

extension VECTestViewController: VECDelegate {
    func onEventTapped(event: Event) {
        print(event.title)
    }
}
#endif

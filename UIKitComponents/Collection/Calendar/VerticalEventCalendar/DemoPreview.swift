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
    let v = VerticalEventCalendar(
        startDate: Date().dateAt(.prevYear))
    
    override func viewDidLoad() {
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
        self.v.add(event: Event(id: testEraseUUID, title: "진짜 테스트다", startDate: "2025-05-03".toDate()!.date, endDate: "2025-05-21".toDate()!.date, calendar: "", color: .systemPink, isAllDay: true))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let title = ["처에", "그림", "아이스크림", "바닐라", "테스트", "요구르트", "비닐"]
            let colors: [UIColor] = [.black, .blue, .cyan, .green, .brown, .darkGray, .gray, .magenta, .orange]
            
            var events: [Event] = []
            var curDate = "2025-07-21".toDate()!.date
            
            for _ in 0...30000 {
                let event = Event(id: UUID().uuidString, title: title.randomElement()!, startDate: curDate, endDate: curDate, calendar: "", color: colors.randomElement()!, isAllDay: true)
                events.append(event)
                curDate = curDate.dateAt(.tomorrow)
            }
            
            
            self.v.add(events: events)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.v.deleteEvent(by: testEraseUUID)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.v.moveScrollToCurrentDateCell()
        }
    }
}

extension VECTestViewController: VECDelegate {
    func onEventTapped(event: Event) {
        print(event.title)
    }
}
#endif

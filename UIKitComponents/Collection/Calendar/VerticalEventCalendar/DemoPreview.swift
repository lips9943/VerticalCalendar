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
        startDate: Date().dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear).dateAt(.prevYear))
    
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
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let title = ["처에", "그림", "아이스크림", "바닐라", "테스트", "요구르트", "비닐"]
            let colors: [UIColor] = [.black, .blue, .cyan, .green, .brown, .darkGray, .gray, .magenta, .orange]
            
            var events: [Event] = []
            var curDate = "2021-07-21".toDate()!.date
            
            for _ in 0...3000 {
                let event = Event(id: UUID().uuidString, title: title.randomElement()!, startDate: curDate, endDate: curDate, calendar: "", color: colors.randomElement()!, isAllDay: true)
                events.append(event)
                curDate = curDate.dateAt(.tomorrow)
            }
            
            
            self.v.add(events: events)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                let title = ["처에", "그림", "아이스크림", "바닐라", "테스트", "요구르트", "비닐"]
                let colors: [UIColor] = [.black, .blue, .cyan, .green, .brown, .darkGray, .gray, .magenta, .orange]
                
                var events: [Event] = []
                var curDate = "2024-07-21".toDate()!.date
                
                for _ in 0...3000 {
                    let event = Event(id: UUID().uuidString, title: title.randomElement()!, startDate: curDate, endDate: curDate, calendar: "", color: colors.randomElement()!, isAllDay: true)
                    events.append(event)
                    curDate = curDate.dateAt(.tomorrow)
                }
                
                
                self.v.add(events: events)
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

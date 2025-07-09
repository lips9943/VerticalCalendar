import Foundation
import RxSwift
import RxCocoa

/// 캘린더 이벤트를 관리하는 매니저입니다.
class MyCalendarEventManager {
    static let shared = MyCalendarEventManager()
    
    private(set) var events: [MyCalendarEventModel] = []
    private var testEvents: BehaviorRelay<[MyCalendarEventModel]> = .init(value: [])
    
    static let eventsUpdatedNotification = Notification.Name("CalendarEventManagerEventsUpdated")
    
    private init() { }
    private let calendar = Calendar.current
    /// 새로운 이벤트를 생성하고 내부 배열에 추가한 후, 업데이트 Notification을 게시합니다.
    func createEvent(title: String, startDate: Date, endDate: Date) -> MyCalendarEventModel {
        let event = MyCalendarEventModel(title: title, startDate: startDate, endDate: endDate)
        events.append(event)
        NotificationCenter.default.post(name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
        return event
    }
    
    
    func event(for date: Date) -> MyCalendarEventModel? {
        var event: MyCalendarEventModel? = nil
        
        // 해당 날짜에 이벤트가 존재하는 확인. 있으면 리턴
        // 해당 날짜가 이벤트 중간에 속해 있는지 확인.
        for e in events {
            if atDate(date, equal: e.startDate) {
                event = e
                event?.eventAtStartDate = true
            }
            
            if isBetweenDates(date, event: e) {
                event = e
                event?.middleOfEvent = true
                event?.eventAtStartDate = false
            }
        }
        
        if let event = event {
            return event
        } else {
            return nil
        }
        
        
        
        
//        return events.map { event in
//            var e = event
//            e.eventAtStartDate = atDate(date, equal: e.startDate)
//            e.eventAtEndDate = atDate(date, equal: e.endDate)
//            if date > e.startDate && date < e.endDate {
//                e.middleOfEvent = true
//            } else {
//                e.middleOfEvent = false
//            }
//            return e
//        }.filter { event in
//            return date >= event.startDate && date <= event.endDate
//        }
    }
    
    // 날짜가 모델 시작날짜와 끝날짜 사이에 있는 지 확인
    private func isBetweenDates(_ date: Date, event: MyCalendarEventModel) -> Bool {
        let startDate = event.startDate
        let endDate = event.endDate
        let currentDate = date
        return currentDate > startDate && currentDate <= endDate
        
    }
    
    // 날짜 비교
    private func atDate(_ date: Date, equal: Date) -> Bool {
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
        let equalComponent = calendar.dateComponents([.year, .month, .day], from: equal)
        return dateComponent.year == equalComponent.year &&
        dateComponent.month == equalComponent.month &&
        dateComponent.day == equalComponent.day
    }
    
    /// 주어진 이벤트의 제목을 업데이트합니다.
    func updateEvent(event: MyCalendarEventModel, newTitle: String) -> Bool {
        if let index = events.firstIndex(of: event) {
            events[index].title = newTitle
            NotificationCenter.default.post(name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
            return true
        }
        return false
    }
    
    /// 주어진 이벤트를 삭제합니다.
    func deleteEvent(event: MyCalendarEventModel) -> Bool {
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
            NotificationCenter.default.post(name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
            return true
        }
        return false
    }
    
    /// 여러 이벤트를 일괄 추가합니다.
    func addEvents(_ newEvents: [MyCalendarEventModel]) {
        events.append(contentsOf: newEvents)
        NotificationCenter.default.post(name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
    }
    
    //
    func deInit() {
        NotificationCenter.default.removeObserver(self, name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
    }
}

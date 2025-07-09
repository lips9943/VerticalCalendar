import Foundation

/// 캘린더 이벤트 모델입니다. 이벤트는 시작 날짜(startDate)와 종료 날짜(endDate)를 가지며,
/// 해당 날짜에 따라 eventAtStartDate, eventAtEndDate, middleOfEvent 플래그가 설정됩니다.
struct MyCalendarEventModel: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date

    // 새로운 플래그들: 기본값은 false
    var middleOfEvent: Bool = false
    var eventAtStartDate: Bool = false
    var eventAtEndDate: Bool = false

    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
    
    private var calendar = Calendar.current
    
    var getBetweenDay: Int? {
        get {
            return calendar.dateComponents([.day], from: startDate, to: endDate).day
        }
    }
    
    func getBetweenDay(_ date: Date) -> Int? {
        return calendar.dateComponents([.day], from: date, to: endDate).day
    }
}

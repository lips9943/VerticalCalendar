import Foundation

/// 한 달의 정보를 담는 모델입니다.
struct MyCalendarMonthModel: Hashable {
    let id = UUID()              // 고유 식별자
    let year: Int                // 연도
    let month: Int               // 월
    var days: [MyCalendarDayModel]              // 해당 달의 Day 모델 배열

    /// 해당 달의 1일의 요일 인덱스를 0부터 시작하는 값으로 반환합니다.
    /// (예: calendar.firstWeekday에 해당하는 요일이 0)
    /// - Parameter calendar: 기준이 되는 Calendar (기본값: Calendar.current)
    /// - Returns: 1일의 요일 인덱스
    func firstDayWeekdayIndex(calendar: Calendar = Calendar.current) -> Int? {
        guard let firstDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            return nil
        }
        let weekday = calendar.component(.weekday, from: firstDate)
        return (weekday - calendar.firstWeekday + 7) % 7
    }
}

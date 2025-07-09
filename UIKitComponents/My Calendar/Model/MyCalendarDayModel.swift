import Foundation

/// 하루의 정보를 담는 모델입니다.
struct MyCalendarDayModel: Hashable {
    let id = UUID()             // 고유 식별자
    let date: Date              // 실제 날짜
    let isWithinDisplayedMonth: Bool  // 현재 달에 속하는 날짜인지 여부
    var event: MyCalendarEventModel? = nil
    
    private let calendar = Calendar.current
    
    var isToday: Bool {
        let today = Date()
        return calendar.isDate(date, inSameDayAs: today)
    }
    
    /// day의 weekday를 구합니다.
    var currentWeekday: Int {
        return calendar.component(.weekday, from: date)
    }
    
    /// day의 month에서 month의 마지막 day를 구합니다.
    var lastDayOfMonth: Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.last!
    }
    
    /// day의 weekOfMonth와 현재 day의 달의 weekOfMonth를 비교하여 같으면  true와 마지막 weekDay를 가져옵니다.
    var isLastWeekOfMonth: (Bool, Int?) {
        // 현재 weekOfMonth를 구합니다.
        let dayOfWeek = calendar.component(.weekOfMonth, from: date)
        
        // 마지막 날의 weekOfMonth를 구합니다.
        let lastDayOfMonth = self.lastDayOfMonth
        var components = calendar.dateComponents([.year,.month], from: self.date)
        components.day = lastDayOfMonth
        guard let lastDateOfMonth = calendar.date(from: components) else { return (false, nil) }
        let lastDayOfWeek = calendar.dateComponents([.weekday, .weekOfMonth], from: lastDateOfMonth)
        return (lastDayOfWeek.weekOfMonth == dayOfWeek, lastDayOfWeek.weekday)
    }
    
    /// day의 weekday와 이벤트의 시작, 끝 date 사이의 것을 비교하여, 라벨을 늘릴 수 있는 multiply를 반환
    func rightPlaceToPutLabel() -> Int? {
        // 이벤트
        guard let event = self.event else { return nil }
        // 이벤트 시작과 끝 날짜가 며칠 차이가 나는 int로.
        guard let betweenEventDate = event.getBetweenDay(self.date) else { return nil }
        // 시작 weekday
        let plusMultiplyNumber = 1
        let startWeekday = self.currentWeekday
        var endWeekday: Int = 7
        
        // MARK: - 현재 start와 end 날짜가 같은 주에 있을 때
        let startWeekOfMonth = calendar.component(.weekOfMonth, from: self.date)
        let endWeekOfMonth = calendar.component(.weekOfMonth, from: event.endDate)
        let isSameWeekOfMonth: Bool = startWeekOfMonth == endWeekOfMonth
        if isSameWeekOfMonth {
            return betweenEventDate + plusMultiplyNumber
        }
        
        // MARK: - 현재 주에 마지막 날짜의 weekDay 가져옵니다.
        // 마지막 주라면 마지막 날의 weekDay를 가져옵니다.
        let (isWeekOfMonth, weekday) = self.isLastWeekOfMonth
        if isWeekOfMonth, let weekday {
            endWeekday = isSameWeekOfMonth ? betweenEventDate : weekday
            return endWeekday - startWeekday + plusMultiplyNumber
        }
        
        return endWeekday - startWeekday  + plusMultiplyNumber
    }
}

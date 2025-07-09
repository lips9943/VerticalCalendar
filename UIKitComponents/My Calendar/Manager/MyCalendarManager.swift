import Foundation

/// 달력 데이터를 생성하는 매니저입니다.
class MyCalendarManager {
    private let calendar = Calendar.current
    
    /// startDate부터 (현재 달 포함 +4개월) 만큼 달력을 생성합니다.
    /// 예) startDate가 2024년 3월이고, 현재 날짜가 2025년 2월이면,
    /// 2024년 3월부터 2025년 2월까지 (12개월) + 4개월 = 총 16개월치 달력을 생성합니다.
    func generateMonths(startDate: Date) -> [MyCalendarMonthModel] {
        var months: [MyCalendarMonthModel] = []
        var currentDate = startDate
        
        // 현재 날짜의 연도, 월 구하기
        let currentComponents = calendar.dateComponents([.year, .month], from: Date())
        let startComponents = calendar.dateComponents([.year, .month], from: startDate)
        
        var diff = 0
        if let currentYear = currentComponents.year,
           let currentMonth = currentComponents.month,
           let startYear = startComponents.year,
           let startMonth = startComponents.month,
           (currentYear > startYear || (currentYear == startYear && currentMonth >= startMonth)) {
            diff = (currentYear - startYear) * 12 + (currentMonth - startMonth) + 1
        } else {
            diff = 1
        }
        
        // 총 생성할 달의 수: 현재 달까지의 개수 + 4개월
        let totalMonths = diff + 4
        
        for _ in 0..<totalMonths {
            guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
                continue
            }
            let range = calendar.range(of: .day, in: .month, for: monthStart)!
            let numberOfDays = range.count
            
            let firstWeekday = calendar.component(.weekday, from: monthStart)
            let firstWeekdayIndex = (firstWeekday - calendar.firstWeekday + 7) % 7
            
            var days: [MyCalendarDayModel] = []
            for _ in 0..<firstWeekdayIndex {
                days.append(MyCalendarDayModel(date: Date(), isWithinDisplayedMonth: false))
            }
            for day in 1...numberOfDays {
                if let dayDate = calendar.date(bySetting: .day, value: day, of: monthStart) {
                    days.append(MyCalendarDayModel(date: dayDate, isWithinDisplayedMonth: true))
                }
            }
            let rows = Int(ceil(Double(firstWeekdayIndex + numberOfDays) / 7.0))
            let totalCells = rows * 7
            while days.count < totalCells {
                days.append(MyCalendarDayModel(date: Date(), isWithinDisplayedMonth: false))
            }
            
            let components = calendar.dateComponents([.year, .month], from: monthStart)
            let monthModel = MyCalendarMonthModel(year: components.year!, month: components.month!, days: days)
            months.append(monthModel)
            
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart) {
                currentDate = nextMonth
            }
        }
        return months
    }
    
    /// 주어진 Month 모델의 다음 달을 생성하여 반환합니다.
    func generateNextMonth(after month: MyCalendarMonthModel) -> MyCalendarMonthModel? {
        let components = DateComponents(year: month.year, month: month.month)
        guard let currentMonthStart = calendar.date(from: components),
              let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: currentMonthStart) else {
            return nil
        }
        let range = calendar.range(of: .day, in: .month, for: nextMonthStart)!
        let numberOfDays = range.count
        let firstWeekday = calendar.component(.weekday, from: nextMonthStart)
        let firstWeekdayIndex = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [MyCalendarDayModel] = []
        for _ in 0..<firstWeekdayIndex {
            days.append(MyCalendarDayModel(date: Date(), isWithinDisplayedMonth: false))
        }
        for day in 1...numberOfDays {
            if let dayDate = calendar.date(bySetting: .day, value: day, of: nextMonthStart) {
                days.append(MyCalendarDayModel(date: dayDate, isWithinDisplayedMonth: true))
            }
        }
        let rows = Int(ceil(Double(firstWeekdayIndex + numberOfDays) / 7.0))
        let totalCells = rows * 7
        while days.count < totalCells {
            days.append(MyCalendarDayModel(date: Date(), isWithinDisplayedMonth: false))
        }
        let comp = calendar.dateComponents([.year, .month], from: nextMonthStart)
        return MyCalendarMonthModel(year: comp.year!, month: comp.month!, days: days)
    }
}

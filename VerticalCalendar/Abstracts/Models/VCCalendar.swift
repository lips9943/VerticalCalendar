//
//  VCCalendar.swift
//  UIKitComponents
//
//  Created by 고혁준 on 9/25/25.
//
import Foundation

public protocol VCCalendar: Equatable {
    associatedtype Month: VCMonth
    associatedtype Day: VCDay
    
    var month: Month { get }
    var days: [Day] { get }
}

public extension VCCalendar {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.month == rhs.month
    }
}

public extension Array<VCCalendar> {
    /// 캘린더 리스트의 개수와 찾고 싶은 Date를 가지고, Date에 속한 달의 캘린더를 index로 반환합니다.
    func index(for date: Date) -> Int? {
        // max Index
        let limitedIndex = self.count - 1
        // 첫번째 값의 캘린더
        guard let firstMonthCalendar = self.first else { return nil }
        
        // 첫번째 캘린더와 date 파라미터의 날짜 차이를 계산하여 인덱스를 반환합니다.
        let index = Calendar.current.dateComponents([.month], from: firstMonthCalendar.month.date, to: date).month!
        guard limitedIndex < index else { return nil }
        return index
    }
}

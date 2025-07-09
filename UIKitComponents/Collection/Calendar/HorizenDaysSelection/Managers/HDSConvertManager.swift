//
//  HDSConvertManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

struct HDSConvertManager {
    func convertToModel(in dates: [Date]) -> [HDSDayModel] {
        return dates.map {
            HDSDayModel(date: $0)
        }
    }
    
    /// 오늘 날짜의 Item 인덱스를 반환
    func convertToIndexPath(in items: [HDSDayModel]) -> IndexPath? {
        let index = items
            .enumerated()
            .filter { (index, item) in
                if item.isToday { return true}
                else { return false}
            }.map { $0.offset }.first
        guard let index  else { return nil}
        return IndexPath(item: index, section: 0)
    }
}

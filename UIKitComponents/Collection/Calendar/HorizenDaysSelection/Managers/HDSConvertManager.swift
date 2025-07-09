//
//  HDSConvertManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

struct HDSConvertManager {
    func convertToModel(in dates: [Date]) -> [HSCDayModel] {
        return dates.map {
            HSCDayModel(date: $0)
        }
    }
}

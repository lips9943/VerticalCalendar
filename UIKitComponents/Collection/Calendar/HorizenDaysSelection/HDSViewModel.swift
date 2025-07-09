//
//  HDSViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

class HDSViewModel {
    let dateManager: HSCDateManager!
    let convertManager: HSCConvertManager!
    let layoutManager: HSCUILayout!
    var days: [HSCDayModel] = []
    
    init() {
        dateManager = HSCDateManager()
        convertManager = HSCConvertManager()
        layoutManager = HSCUILayout()
        days = convertManager.convertToModel(in: dateManager.generateDays())
    }
}

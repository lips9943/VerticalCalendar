//
//  HDSViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

class HDSViewModel {
    let dateManager: HDSDateManager!
    let convertManager: HDSConvertManager!
    let layoutManager: HDSUILayout!
    
    var days: [HDSDayModel] = []
    
    init() {
        dateManager = HDSDateManager()
        convertManager = HDSConvertManager()
        layoutManager = HDSUILayout()
        days = convertManager.convertToModel(in: dateManager.generateDays())
    }
    
    func getIndexPathForToday() -> IndexPath? {
        return convertManager.convertToIndexPath(in: days)
    }
}

//
//  HDSUILayout.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//
import UIKit

struct HDSUILayout {
    func setLayout(with fixedHeight: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: fixedHeight * 0.78,
                                height: fixedHeight * 0.8)
        
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

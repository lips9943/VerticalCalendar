//
//  HDSTableView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

import UIKit

class HDSCollectionView: UICollectionView {
    var layout: UICollectionViewFlowLayout?
    
    init(layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        self.layout = layout as? UICollectionViewFlowLayout
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(HDSCollectionViewCell.self,
                 forCellWithReuseIdentifier: HDSCollectionViewCell.identifier)
    }
}

//
//  VECCollectionView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

import UIKit

class VECCollectionView: UICollectionView {
    var topInset: CGFloat = 0 {
        didSet { self.contentInset.top = topInset }
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        setUpView()
        setUpRegister()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        
    }
    
    private func setUpRegister() {
        register(VECDayCell.self, forCellWithReuseIdentifier: VECDayCell.reuseIdentifier)
        register(VECReusableMonth.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: VECReusableMonth.identifier)
    }
}

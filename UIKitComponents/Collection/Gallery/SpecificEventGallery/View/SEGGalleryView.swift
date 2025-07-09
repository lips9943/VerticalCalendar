//
//  SEGGalleryView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//

import UIKit
internal import RxSwift
internal import RxCocoa

class SEGGalleryView: UICollectionView {
    private let vm: SEGViewModel!
    
    init(collectionViewLayout layout: UICollectionViewLayout, vm: SEGViewModel) {
        self.vm = vm
        super.init(frame: .zero, collectionViewLayout: layout)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.register(SEGGalleryCell.self, forCellWithReuseIdentifier: SEGGalleryCell.reuseIdentifier)
        
    }
}

extension SEGGalleryView {
    
}

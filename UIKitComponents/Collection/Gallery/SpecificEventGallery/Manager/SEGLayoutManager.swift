//
//  LayoutManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//
import UIKit

class SEGLayoutManager {
    func defaultLayout() -> UICollectionViewCompositionalLayout {
        // Item
        let widthDimenstion = NSCollectionLayoutDimension.fractionalWidth(1.0/3.0)
        let itemSize = NSCollectionLayoutSize(widthDimension: widthDimenstion, heightDimension: widthDimenstion)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupHeightDimentsion = NSCollectionLayoutDimension.fractionalWidth((1.0/3.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeightDimentsion)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2.5)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

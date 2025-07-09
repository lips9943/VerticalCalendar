//
//  VECLayout.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import UIKit

struct VECLayout {
    
    
    init() {}
    
    func createLayout() -> UICollectionViewLayout {
        return createCompositionalLayout()
    }
}

extension VECLayout {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let collectionHeight = UIScreen.main.bounds.height
        let headerHeight: CGFloat = 30
        let gridHeight = collectionHeight - headerHeight
        let rows: CGFloat = 6
        let itemHeight = gridHeight / rows
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/7.0),
                                              heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item, count: 7)
        
        let sectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(itemHeight * rows))
        let sectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: sectionGroupSize,
                                                            repeatingSubitem: group,
                                                            count: Int(rows))
        
        let section = NSCollectionLayoutSection(group: sectionGroup)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return UICollectionViewCompositionalLayout(section: section)
    }
}

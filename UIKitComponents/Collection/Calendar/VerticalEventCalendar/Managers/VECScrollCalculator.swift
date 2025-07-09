//
//  VECInfiniteScrollCalculator.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/22/25.
//
import UIKit
import DSA
internal import SwiftDate

struct VECScrollCalculator {
    func isOffsetYAtBottomEdge(positionData: VECPositions) -> Bool {
        let offsetY = positionData.contentOffset.y
        let contentheight = positionData.contentSize.height
        let safeAreaInsets = positionData.safeAreaInsets
        let contentInsetTop = positionData.contentInsets.top
        let height = positionData.bounds.height
        
        // 정확한 offset Y
        let exactOffsetY = offsetY - safeAreaInsets.top - contentInsetTop + height
        
        return exactOffsetY > contentheight - 100
    }
    
    func calculateTodayCellsLocation(_ collectionView: UICollectionView, calendars: [VECSection]) -> CGPoint? {
        var sectionIndex: Int?
        let today = Date.nowAt(.startOfMonth)
        
        for (index, calendar) in calendars.enumerated() {
            if calendar.month.date.compare(.isSameMonth(today)) {
                sectionIndex = index
            }
        }
        
        guard let sectionIndex else { return nil }
        guard let todayMonthSupplementView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: sectionIndex)) else { return nil }
        
        return todayMonthSupplementView.frame.origin
    }
    
    ///
    func calculateOffsetAfterAddingData(collectionView: UICollectionView, calendars: [VECSection]) -> CGFloat {
        // Get Section Height
        let rows = CGFloat(calendars[0].month.date.dateAt(.endOfMonth).weekOfMonth)
        
        let offset = collectionView.contentOffset
        
        // Get Cell's Height
        guard let currentCellIndexPath = collectionView.indexPath(for: collectionView.visibleCells[0]) else { return 0 }
        guard let crtOffsetYTouchsCellHeight = collectionView.cellForItem(at: currentCellIndexPath)?.bounds.height else { return 0 }
        
        //
        let sectionHeight: CGFloat = 30
        
        //
        let totalSectionHeight = (crtOffsetYTouchsCellHeight * rows) + sectionHeight
        
        //
        return (offset.y + totalSectionHeight)
    }
    
}

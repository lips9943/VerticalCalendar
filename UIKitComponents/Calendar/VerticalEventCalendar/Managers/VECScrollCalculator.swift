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
    enum Direction {
        case top, bottom
    }
    
    func calculateDirection(_ collectionView: UICollectionView) -> Direction? {
        // 재료들
        let offsetY = collectionView.contentOffset.y
        let contentSizeHeight = collectionView.contentSize.height
        let contentInsetTop = collectionView.contentInset.top
        let safeAreaInsets = collectionView.safeAreaInsets
        let frameHeight = collectionView.frame.height
        
        // 정확한 Content Offset Y
        let topY = offsetY + contentInsetTop + safeAreaInsets.top
        let bottomY = offsetY + frameHeight - safeAreaInsets.bottom
        let newThreshold = frameHeight
        
        if topY < newThreshold {
            return .top
        } else if bottomY > contentSizeHeight - newThreshold {
            return .bottom
        }
        return nil
    }
    
    ///
    func calculateTodayCellsLocation(_ collectionView: UICollectionView, calendars: LinkedList<VECSection>) -> CGPoint? {
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
    func calculateOffsetAfterAddingData(collectionView: UICollectionView, calendars: LinkedList<VECSection>) -> CGFloat {
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

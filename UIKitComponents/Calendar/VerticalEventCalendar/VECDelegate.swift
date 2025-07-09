//
//  VECDelegate.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

import UIKit
import DSA

extension VEC: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        con()
        if isStarted {
            infiniteScroll()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isStarted = true
            }
        }
    }
}

// MARK: - Year View Configuration
extension VEC {
    private func con() {
        let offsetY = collectionView.contentOffset.y
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout,
              let attributesArray = layout.layoutAttributesForElements(in: self.collectionView.bounds) else { return }
        
        // 1) 화면에 들어온 헤더만 필터링
        let visibleHeaders = attributesArray
            .filter { $0.representedElementKind == UICollectionView.elementKindSectionHeader }
            // 헤더 frame이 현재 화면(bounds)과 어느 정도 겹치는지 확인
            .filter { $0.frame.maxY >= offsetY && $0.frame.minY <= offsetY + (collectionView.bounds.height / 2) }
            // ↑ maxY가 offsetY보다 크고, minY가 offsetY + 화면높이보다 작으면 (즉, 화면과 겹치면) visible하다고 볼 수 있음
        
        // 2) 화면 상단에 가장 가까운 헤더(즉, minY가 가장 작은 것) 하나 뽑기
        guard let topHeader = visibleHeaders.max(by: { $0.frame.minY < $1.frame.minY }) else { return }
                
        // 3) 해당 헤더의 섹션으로부터 Month 정보를 가져오기
        let currentMonth = viewModel.calendars[topHeader.indexPath.section]
        let currentYear = currentMonth.month.date.year
        
        guard currentYear != self.currentYear else { return }
        
        topYearView.textChange(text: currentMonth.month.date.year.description)
        self.currentYear = currentMonth.month.date.year
    }
}

// MARK: - Infinite Scroll Function
extension VEC {
    private func infiniteScroll() {
        guard let direction = viewModel.activateInfiniteScroll(collectionView: collectionView) else { return }
//        UIView.setAnimationsEnabled(false)
        
        var addSectionIndex: IndexSet?
        var calendars = viewModel.calendars
        
        let oldOffset = collectionView.contentOffset
        let startedHeight = collectionView.contentSize.height
        
        collectionView.performBatchUpdates {
            addSectionIndex = viewModel.addCalendarWithSectionsIndex(direction, calendars: &calendars)
            guard let addSectionIndex else { return }
            
            viewModel.calendars = calendars
            
            self.collectionView.insertSections(addSectionIndex)
        } completion: { _ in
            if direction == .top {
                let changedHeight = self.collectionView.contentSize.height
                let heightDifference = changedHeight - startedHeight
                
                //                        self.setScrollLocationWithDirection(heightDifference: heightDifference, oldOffset: oldOffset)
            }
            
            self.viewModel.deactivate(after: 0.2)
            //            UIView.setAnimationsEnabled(true)
        }
        

        
        
    }
    
    private func setScrollLocationWithDirection(heightDifference: CGFloat, oldOffset: CGPoint) {
        let newOffset = CGPoint(x: oldOffset.x, y: oldOffset.y + heightDifference)
        collectionView.contentOffset = newOffset
    }
}

//
//  HDSDelegate.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/16/25.
//
import UIKit

extension HorizenDaysSelection: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = viewModel.days[indexPath.item].date
        self.itemDidSelected?(date)
    }
}

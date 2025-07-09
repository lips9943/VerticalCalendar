//
//  VECCalculatedDatas.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/21/25.
//
import UIKit

struct VECPositions {
    var contentSize: CGSize
    var contentOffset: CGPoint
    var contentInsets: UIEdgeInsets
    var safeAreaInsets: UIEdgeInsets
    var frame: CGRect
    var bounds: CGRect
    var delta: CGFloat?
    
    init(collectionView: UICollectionView) {
        self.contentInsets = collectionView.contentInset
        self.contentOffset = collectionView.contentOffset
        self.contentSize = collectionView.contentSize
        self.safeAreaInsets = collectionView.safeAreaInsets
        self.frame = collectionView.frame
        self.bounds = collectionView.bounds
    }
    
    init(tableView: UITableView) {
        self.contentSize = tableView.contentSize
        self.contentInsets = tableView.contentInset
        self.contentOffset = tableView.contentOffset
        self.safeAreaInsets = tableView.safeAreaInsets
        self.frame = tableView.frame
        self.bounds = tableView.bounds
    }
    
    init(scrollView: UIScrollView) {
        self.contentSize = scrollView.contentSize
        self.contentInsets = scrollView.contentInset
        self.contentOffset = scrollView.contentOffset
        self.safeAreaInsets = scrollView.safeAreaInsets
        self.frame = scrollView.frame
        self.bounds = scrollView.bounds
    }
}

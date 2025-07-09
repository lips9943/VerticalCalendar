//
//  HDSDatasource.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//
import UIKit

extension HorizenDaysSelection: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HDSCollectionViewCell.identifier, for: indexPath) as? HDSCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(model: viewModel.days[indexPath.item], viewModel: viewModel)
        return cell
    }
}

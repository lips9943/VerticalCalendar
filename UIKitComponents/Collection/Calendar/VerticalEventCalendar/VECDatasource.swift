//
//  VECDatasource.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

import UIKit

extension VerticalEventCalendar: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.calendars[section].days.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.calendars.count
    }
    
    /// Day Cell 설정.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dayModel = viewModel.calendars[indexPath.section].days[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VECDayCell.reuseIdentifier, for: indexPath) as? VECDayCell else { return UICollectionViewCell() }
        cell.configure(model: dayModel)
        cell.delegate = self
        return cell
    }
    
    /// Month Header 설정.
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VECReusableMonth.identifier, for: indexPath) as? VECReusableMonth else { return UICollectionReusableView() }
        let monthModel = viewModel.calendars[indexPath.section].month
        view.update(with: monthModel)
        return view
    }
}

extension VerticalEventCalendar: VECDayCellDelegate {
    func didEventTap(event: VECEvent) {
        delegate?.onEventTapped(event: Event.invert(event))
    }
}

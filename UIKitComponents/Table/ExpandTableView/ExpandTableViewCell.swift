//
//  ExpandTableViewCell.swift
//  UIKitComponents
//
//  Created by 고혁준 on 3/29/25.
//
import UIKit
import Combine


open class ExpandTableViewCell: UITableViewCell {
    public var isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
    public var cancellables = Set<AnyCancellable>()
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        isExpanded.send(false)
        cancellables.removeAll() // Cancellables 초기화
    }
    
    public func setExpandable(_ tableView: ExpandTableView, indexPath: IndexPath) {
        tableView.selectedIndex
            .map { $0 == indexPath }
            .sink { [weak self] in self?.isExpanded.send($0) }
            .store(in: &cancellables)
    }
}

//
//  SpreadTableView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 3/24/25.
//

import UIKit
import Combine
internal import RxSwift
internal import RxCocoa

open class ExpandTableView: UITableView {
    private var cancellables = Set<AnyCancellable>()
    private let bag = DisposeBag()
    let selectedIndex = CurrentValueSubject<IndexPath?, Never>(nil)
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        configuration()
    }
}

extension ExpandTableView {
    private func configuration() {
        self.rx.itemSelected.bind { [weak self] indexPath in
            guard let self else { return }
            
            let currentIndex = self.selectedIndex.value
            self.selectedIndex.send(currentIndex == indexPath ? nil : indexPath)
//            self.beginUpdates()
//            self.endUpdates()
            
            
        }.disposed(by: bag)
    }
}


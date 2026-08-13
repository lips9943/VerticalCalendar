//
//  VCDayCellTopBorder.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/3/25.
//

import UIKit
#if os(iOS)
class VCDayCellTopBorder: UIView {
    var parent: UIView!
    init(parent: UIView) {
        self.parent = parent
        super.init(frame: .zero)
        self.backgroundColor = .systemGray5
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            topAnchor.constraint(equalTo: parent.topAnchor),
            heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with day: any VCDay) {
        guard !day.isPrevMonthDay else { return }
        self.isHidden = false
    }
    
    func prepare() {
        self.isHidden = true
    }
}
#endif

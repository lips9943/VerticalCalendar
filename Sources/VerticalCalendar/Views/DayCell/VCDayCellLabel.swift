//
//  VCDayCellLabel.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/3/25.
//

import UIKit
#if os(iOS)
class VCDayCellLabel: UILabel {
    let parent: UIView
    init(parent: UIView) {
        self.parent = parent
        super.init(frame: .zero)
        parent.addSubview(self)
        setLabel()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: any VCDay) {
        guard !model.isPrevMonthDay else { return }
        self.isHidden = false
        self.text = String(model.day)
        self.setTodayLabel(model)
        if model.calendar.isDateInWeekend(model.date) {
            self.textColor = .systemGray2
        } else {
            self.textColor = .label
        }
    }
    
    func prepare() {
        self.isHidden = true
        self.text = nil
        self.textColor = .clear
        self.backgroundColor = .clear
    }
    
    private func setTodayLabel(_ model: any VCDay) {
        guard model.isToday else { return }
        self.backgroundColor = .systemTeal.withAlphaComponent(0.1)
    }
    
    private func setLabel() {
        self.isHidden = true
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
        let device = UIDevice.current.userInterfaceIdiom
        if device == .phone {
            self.font = .preferredFont(forTextStyle: .body)
        } else if device == .pad || device == .mac {
            self.font = .preferredFont(forTextStyle: .title2)
        } else {
            self.font = .preferredFont(forTextStyle: .body)
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.topAnchor.constraint(equalTo: parent.topAnchor/*, constant: screenSize.height * 0.2*/),
            self.heightAnchor.constraint(equalToConstant: parent.frame.height * 0.24)
        ])
    }
}
#endif

//
//  VCDayCellLabel.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/3/25.
//

import UIKit
#if os(iOS)
public class VCDayCellLabel: UIView {
    let parent: UIView
    public var dayLabel: UILabel!
    
    init(parent: UIView) {
        self.parent = parent
        super.init(frame: .zero)
        parent.addSubview(self)
        setToday()
        
        dayLabel = setLabel()
        parent.addSubview(dayLabel)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: any VCDay) {
        guard !model.isPrevMonthDay else { return }
        self.dayLabel.isHidden = false
        self.dayLabel.alpha = 1
        self.dayLabel.text = String(model.day)
        self.setTodayLabel(model)
        if model.calendar.isDateInWeekend(model.date) {
            self.dayLabel.textColor = .systemGray2
        } else {
            self.dayLabel.textColor = .label
        }
    }
    
    func prepare() {
        self.isHidden = true
        self.dayLabel.text = nil
        self.dayLabel.textColor = .clear
        self.dayLabel.backgroundColor = .clear
        self.dayLabel.isHidden = true
    }
    
    func setTodayLabel(_ model: any VCDay) {
        guard model.isToday else { return }
        self.isHidden = false
        self.backgroundColor = .systemTeal.withAlphaComponent(0.1)
    }
    
    private func setLabel() -> UILabel {
        let l = UILabel()
        l.isHidden = true
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.7
        let device = UIDevice.current.userInterfaceIdiom
        if device == .phone {
            l.font = .preferredFont(forTextStyle: .body)
        } else if device == .pad || device == .mac {
            l.font = .preferredFont(forTextStyle: .title2)
        } else {
            l.font = .preferredFont(forTextStyle: .body)
        }
        
        return l
    }
    
    private func setToday() {
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.topAnchor.constraint(equalTo: parent.topAnchor/*, constant: screenSize.height * 0.2*/),
            self.heightAnchor.constraint(equalToConstant: parent.frame.height * 0.26),
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
#endif

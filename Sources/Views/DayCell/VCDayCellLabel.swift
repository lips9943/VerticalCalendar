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
    
    /// Label View의 높이를 정합니다. 기준은 Superview의 높이가 되고 몇%를 소수점으로 표현하느냐의 따라서 높이가 결정됩니다.
    /// 기본 값은 0.23(23%)입니다.
    public static var labelHeight: CGFloat = 0.23
    /// Superview 높이에 비례하여 몇 %를 차지하는 것을 기준으로 Top 마진을 설정합니다. 기본 값은 0.06 (6%)
    public static var topMargin: CGFloat = 0.06
    /// Superview 길이에 비례하여 몇 %를 차지하는 것을 기준으로 Horizontal 마진을 설정합니다. 기본 값은 0.01(1%)
    public static var horizontalMargin: CGFloat = 0.01
    
    public private(set) var dayLabel: UILabel!
    
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
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: parent.frame.width * Self.horizontalMargin),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -(parent.frame.width * Self.horizontalMargin)),
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: parent.frame.height * Self.topMargin),
            self.heightAnchor.constraint(equalToConstant: parent.frame.height * VCDayCellLabel.labelHeight),
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
#endif

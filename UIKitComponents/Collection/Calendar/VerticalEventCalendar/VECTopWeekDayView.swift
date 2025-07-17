//
//  VECTopYearView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/2/25.
//
import UIKit
internal import SnapKit

class VECTopWeekDayView: UIView {
    private var weekStackView: UIStackView!
    private var weekLabels: [UILabel]!
    private var blurView: CustomBlurView!
    private var locale: Locale!
    
    var weekDayLabelColor: UIColor = .label {
        didSet {
            for i in 1...5 {
                weekLabels[i].textColor = weekDayLabelColor
            }
        }
    }
    var sundayLabelColor: UIColor = .systemRed {
        didSet { weekLabels[0].textColor = sundayLabelColor }
    }
    var saturdayLabelColor: UIColor = .systemGray2 {
        didSet { weekLabels.last?.textColor = saturdayLabelColor }
    }
    
    init(locale: Locale) {
        self.locale = locale
        self.blurView = CustomBlurView()
        super.init(frame: .zero)
        
        weekLabels = makeWeekLabels()
        weekStackView = UIStackView(arrangedSubviews: weekLabels)
        setUpBlurView()
        setUpStackView()
        addAllSubviewsInTheView()
        setAllLayoutsInTheView()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviewsInTheView() {
        addSubview(blurView)
        addSubview(weekStackView)
    }
    
    private func setAllLayoutsInTheView() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        weekStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension VECTopWeekDayView {
    private func setUpBlurView() {
        blurView.blurEffect = .systemUltraThinMaterial
        blurView.contentView.backgroundColor = .clear
        blurView.backgroundColor = .clear
    }
    
    private func setUpStackView() {
        weekStackView.axis = .horizontal
        weekStackView.distribution = .fillEqually
        weekStackView.alignment = .fill
        weekStackView.backgroundColor = .clear
    }
    
    private func makeWeekLabels() -> [UILabel] {
        let format = DateFormatter()
        format.dateStyle = .short
        format.locale = self.locale
        format.dateFormat = "EEEE"
        
        var weekLabels: [UILabel] = []
        for i in 0..<7 {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.textColor = .black
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.text = format.shortWeekdaySymbols[i]
            label.textColor = i == 0 ? .systemRed : .systemGray2
            weekLabels.append(label)
        }
        
        return weekLabels
    }
}


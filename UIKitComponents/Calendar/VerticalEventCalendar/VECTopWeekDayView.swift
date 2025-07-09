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
    
    init() {
        super.init(frame: .zero)
        weekLabels = makeWeekLabels()
        weekStackView = UIStackView(arrangedSubviews: weekLabels)
        setUpStackView()
        addAllSubviewsInTheView()
        setAllLayoutsInTheView()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubviewsInTheView() {
        addSubview(weekStackView)
    }
    
    private func setAllLayoutsInTheView() {
        weekStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension VECTopWeekDayView {
    private func setUpStackView() {
        weekStackView.axis = .horizontal
        weekStackView.distribution = .fillEqually
        weekStackView.alignment = .fill
    }
    
    private func makeWeekLabels() -> [UILabel] {
        let format = DateFormatter()
        format.dateStyle = .short
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "EEEE"
        
        var weekLabels: [UILabel] = []
        for i in 0..<7 {
            let label = UILabel()
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


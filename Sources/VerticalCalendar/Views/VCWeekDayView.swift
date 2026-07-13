//
//  VCWeekDayView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/18/26.
//

import UIKit


class VCWeekDayView: UIView {
    private var stackView: UIStackView!
    private var weekLabels: [UILabel] = {
        return (0..<7).map { _ in UILabel() }
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupStackView()
        setupLabelViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .lastBaseline
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.stackView = stackView
    }
    
    private func setupLabelViews() {
        let calendar = Calendar.current
        for (index, label) in weekLabels.enumerated() {
            let weekday = calendar.shortWeekdaySymbols[index].capitalized
            label.text = weekday
            label.textAlignment = .center
            label.numberOfLines = 1
            label.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
            label.layer.masksToBounds = false
            
            label.layer.shadowColor = UIColor.label.cgColor
            label.layer.shadowOpacity = 0.15
            label.layer.shadowOffset = .init(width: 0.5, height: 2)
            self.stackView.addArrangedSubview(label)
            if index == 0 || index == 6 {
                label.textColor = .systemGray.withAlphaComponent(0.9)
            } else {
                label.textColor = .label.withAlphaComponent(0.9)
            }
        }
    }
    
    func configure(with view: UIView) {
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

//
//  VCWeekDayView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/18/26.
//

import UIKit

class VCWeekDayView: UIView {
    private var visualView: UIVisualEffectView!
    private var stackView: UIStackView!
    private var weekLabels: [UILabel] = {
        return (0..<7).map { _ in UILabel() }
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
//        setupVisualView()
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
            label.font = .preferredFont(forTextStyle: .caption1)
            self.stackView.addArrangedSubview(label)
            if index == 0 || index == 6 {
                label.textColor = .systemGray.withAlphaComponent(0.7)
            } else {
                label.textColor = .label.withAlphaComponent(0.7)
            }
        }
    }
    
    private func setupVisualView() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.3
        blurView.backgroundColor = .clear
        self.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with view: UIView) {
        let screenBounds: CGRect = UIScreen.main.bounds
        
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: screenBounds.height * 0.02)
        ])
    }
}

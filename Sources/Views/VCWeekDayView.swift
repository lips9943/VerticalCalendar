//
//  VCWeekDayView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/18/26.
//

import SwiftUI

public class VCWeekDayView: UIView {
    private var stackView: UIStackView!
    private var weekLabels: [UILabel] = {
        return (0..<7).map { _ in UILabel() }
    }()
    
    private var bottomLine: UIView?
    private var blurView: UIVisualEffectView?
    
    
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
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
            label.font = .monospacedDigitSystemFont(ofSize: 10, weight: .medium)
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
    
    public func setBlur(with style: UIBlurEffect.Style) {
        self.blurView?.removeFromSuperview()
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurView)
        sendSubviewToBack(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.blurView = blurView
        setBottomBorder()
    }
    
    public func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        
    }
    
    public func setBottomBorder() {
        self.bottomLine?.removeFromSuperview()
        let l = UIView()
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = .secondarySystemBackground
        
        addSubview(l)
        bringSubviewToFront(l)
        
        NSLayoutConstraint.activate([
            l.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            l.leadingAnchor.constraint(equalTo: leadingAnchor),
            l.trailingAnchor.constraint(equalTo: trailingAnchor),
            l.heightAnchor.constraint(equalToConstant: 1.5)
        ])
        
        bottomLine = l
    }
    
    public func configure(with view: UIView) {
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

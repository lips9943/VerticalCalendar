//
//  VCYearView.swift
//  VerticalCalendar
//
//  Created by Jun on 12/11/25.
//

import UIKit

class VCYearView: UILabel {
    private lazy var date: Date = .now
    private var hideWorkItem: DispatchWorkItem?
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        let year: String? = date.year?.description
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 1
        self.backgroundColor = .clear
        self.textColor = .tertiaryLabel
        self.textAlignment = .center
        self.text = year
        self.layer.opacity = 0
        self.font = .monospacedDigitSystemFont(ofSize: 35, weight: .heavy)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -3, height: 1.5)
        self.layer.shadowOpacity = 5
    }
    
    func update(with date: Date) {
        guard date.year != self.date.year else { return }
        let newYear = date.year?.description
        
        self.text = newYear
        self.layer.opacity = 1
        self.date = date
        self.hideWorkItem?.cancel()
        
        let execute = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.5) {
                self?.layer.opacity = 0
            }
        }
          
        self.hideWorkItem = execute
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, execute: execute)
    }
    
    func configure(_ superView: UIView) {
        let screenBounds: CGRect = UIScreen.main.bounds
        superView.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: screenBounds.width * 0.05),
            self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: screenBounds.height * 0.02),
        ])
    }
}

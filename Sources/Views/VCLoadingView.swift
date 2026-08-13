//
//  VCLoadingView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/22/26.
//
import UIKit

open class VCLoadingView: UIView {
    public weak var vc: VCalendar?
    
    public var indicator: UIActivityIndicatorView!
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground.withAlphaComponent(0.2)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configureIndicator() {
        let i = UIActivityIndicatorView(style: .medium)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.hidesWhenStopped = true
        
        addSubview(i)
        NSLayoutConstraint.activate([
            i.centerXAnchor.constraint(equalTo: centerXAnchor),
            i.centerYAnchor.constraint(equalTo: centerYAnchor),
            i.widthAnchor.constraint(equalToConstant: 50),
            i.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        indicator = i
    }
    
    open func configure(calendar: some VCalendar) {
        self.vc = calendar
        calendar.view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: calendar.view.topAnchor),
            leadingAnchor.constraint(equalTo: calendar.view.leadingAnchor),
            bottomAnchor.constraint(equalTo: calendar.view.bottomAnchor),
            trailingAnchor.constraint(equalTo: calendar.view.trailingAnchor)
        ])
    }
    
    open func setLoading(value: Bool) {
        if value {
            indicator.startAnimating()
            self.isHidden = false
        } else {
            indicator.stopAnimating()
            self.isHidden = true
        }
    }
}

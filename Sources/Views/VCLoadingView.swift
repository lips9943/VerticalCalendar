//
//  VCLoadingView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/22/26.
//
import UIKit
public protocol LoadingSet {
    func setLoading(value: Bool)
    func configure(calendar: some VCalendar)
}

class VCLoadingView: UIView, LoadingSet {
    private weak var vc: VCalendar?
    
    var loadingComponent: UIActivityIndicatorView = {
        let aIV = UIActivityIndicatorView(style: .medium)
        aIV.translatesAutoresizingMaskIntoConstraints = false
        aIV.hidesWhenStopped = true
        return aIV
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(calendar: some VCalendar) {
        addSubview(loadingComponent)
        NSLayoutConstraint.activate([
            loadingComponent.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingComponent.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingComponent.widthAnchor.constraint(equalToConstant: 50),
            loadingComponent.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        self.vc = calendar
        calendar.view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: calendar.view.topAnchor),
            leadingAnchor.constraint(equalTo: calendar.view.leadingAnchor),
            bottomAnchor.constraint(equalTo: calendar.view.bottomAnchor),
            trailingAnchor.constraint(equalTo: calendar.view.trailingAnchor)
        ])
    }
    
    func setLoading(value: Bool) {
        if value {
            loadingComponent.startAnimating()
            self.isHidden = false
        } else {
            loadingComponent.stopAnimating()
            self.isHidden = true
        }
    }
}

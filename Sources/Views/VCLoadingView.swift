//
//  VCLoadingView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/22/26.
//
import UIKit

class VCLoadingView: UIView {
    private weak var vc: VCalendar?
    
    public var loadingComponent: UIView! = {
        let aIV = UIActivityIndicatorView(style: .medium)
        aIV.translatesAutoresizingMaskIntoConstraints = false
        aIV.hidesWhenStopped = true
        return aIV
    }()
    
    var isLoading: String?
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(calendar: VCalendar) {
        if let aIV = loadingComponent as? UIActivityIndicatorView {
            addSubview(aIV)
            NSLayoutConstraint.activate([
                aIV.centerXAnchor.constraint(equalTo: centerXAnchor),
                aIV.centerYAnchor.constraint(equalTo: centerYAnchor),
                aIV.widthAnchor.constraint(equalToConstant: 50),
                aIV.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
        
        self.vc = calendar
        calendar.view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: calendar.view.topAnchor),
            leadingAnchor.constraint(equalTo: calendar.view.leadingAnchor),
            bottomAnchor.constraint(equalTo: calendar.view.bottomAnchor),
            trailingAnchor.constraint(equalTo: calendar.view.trailingAnchor)
        ])
    }
    
    open func setLoading(title: String?) {
        let aIV = loadingComponent as? UIActivityIndicatorView
        
        if let title, !title.isEmpty {
            aIV?.startAnimating()
            self.isLoading = title
            self.isHidden = false
        } else {
            aIV?.stopAnimating()
            self.isLoading = nil
            self.isHidden = true
        }
    }
}

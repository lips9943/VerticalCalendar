//
//  VCLoadingView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/22/26.
//
import UIKit

public final class VCLoadingView: UIView {
    private var aIV: UIActivityIndicatorView!
    private weak var vc: VCalendar?
    
    var isLoading: Bool { aIV.isAnimating }
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        aIV = UIActivityIndicatorView(style: .medium)
        aIV.translatesAutoresizingMaskIntoConstraints = false
        aIV.hidesWhenStopped = true
        addSubview(aIV)
        NSLayoutConstraint.activate([
            aIV.centerXAnchor.constraint(equalTo: centerXAnchor),
            aIV.centerYAnchor.constraint(equalTo: centerYAnchor),
            aIV.widthAnchor.constraint(equalToConstant: 50),
            aIV.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(calendar: VCalendar) {
        self.vc = calendar
        calendar.view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: calendar.view.topAnchor),
            leadingAnchor.constraint(equalTo: calendar.view.leadingAnchor),
            bottomAnchor.constraint(equalTo: calendar.view.bottomAnchor),
            trailingAnchor.constraint(equalTo: calendar.view.trailingAnchor)
        ])
    }
    
    func startLoading() {
        aIV.startAnimating()
        self.isHidden = false
    }
    
    func stopLoading() {
        aIV.stopAnimating()
        self.isHidden = true
    }
}

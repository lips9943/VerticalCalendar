//
//  SEGNavigationSetUp.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//
import UIKit


extension SEGViewController {
    func setUpNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(whenPlusButtonClicked))
    
    }
    
    @objc func whenPlusButtonClicked() {
        delegate?.plusButtonTapped()
    }
}


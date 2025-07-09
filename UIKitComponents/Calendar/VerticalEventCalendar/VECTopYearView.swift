//
//  VECTopYearView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/4/25.
//

import UIKit
internal import SnapKit

class VECTopYearView: UILabel {
    private var hideWorkItem: DispatchWorkItem?
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        text = "2025"
        textColor = .white
        textAlignment = .center
        font = .boldSystemFont(ofSize: 29)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5
        alpha = 0
    }
    
    func textChange(text: String) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            // 텍스트 설정 및 표시
            self.text = text
            self.alpha = 1
            
            // 이전 hide 작업이 있다면 취소
            self.hideWorkItem?.cancel()
            
            // 새로운 hide 작업 생성
            let workItem = DispatchWorkItem { [weak self] in
                UIView.animate(withDuration: 0.4) {
                    self?.alpha = 0
                }
            }
            
            self.hideWorkItem = workItem
            
            // 3초 뒤에 실행
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
        }
    }
}

//
//  VECEventView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 5/23/25.
//
import UIKit
internal import SnapKit

class VECEventView: UIView {
    
    private var labelView = UILabel()
    
    var event: VECEvent!
    
    
    init(event: VECEvent) {
        self.event = event
        super.init(frame: .zero)
    }
    
    deinit {
        event = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReUse() {
        // 이벤트 뷰 초기화
//            eventView.isHidden = true
        self.backgroundColor = .clear
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = []
        
        // 이벤트 뷰의 모든 제약조건 제거
        self.snp.removeConstraints()
        
        // 이벤트 라벨 초기화
        
        labelView.text = nil
        labelView.isHidden = true
    }
    
    
    // MARK: - 코너 라디우스 적용
    func applyCornerRadius(isStartDate: Bool, isEndDate: Bool) {
        let radius: CGFloat = 4
        layer.masksToBounds = true
        
        if isStartDate && isEndDate {
            // 단일 날짜 이벤트 (모든 코너 둥글게)
            layer.cornerRadius = radius
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else if isStartDate {
            // 시작일 (왼쪽 코너만 둥글게)
            layer.cornerRadius = radius
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if isEndDate {
            // 종료일 (오른쪽 코너만 둥글게)
            layer.cornerRadius = radius
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            // 중간 날짜 (코너 없음)
            layer.cornerRadius = 0
            layer.maskedCorners = []
        }
    }
}

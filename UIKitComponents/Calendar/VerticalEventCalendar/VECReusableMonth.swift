//
//  VECReusableMonth.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

import UIKit

class VECReusableMonth: UICollectionReusableView {
    static let identifier: String = "VECReusableMonth"
    static var monthLabelColor: UIColor = .systemGray2
    
    private let stackView = UIStackView()
    private var slotLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        slotLabels.forEach { $0.text = nil }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 스택뷰를 생성하여 7개의 슬롯(라벨)을 추가합니다.
    private func setupHeader() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        // 좌우 constant 제거하여 딱 붙게 설정
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
        }
        
        for _ in 0..<7 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = VECReusableMonth.monthLabelColor
            slotLabels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    /// Month 모델을 받아 해당 달의 1일의 요일 슬롯에 "\(month.month)월" 텍스트를 표시합니다.
    func update(with month: VECMonth) {
        slotLabels[month.date.weekday - 1].text = "\(month.date.month)월"
    }
}

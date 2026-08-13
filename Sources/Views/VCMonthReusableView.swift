//
//  VCMonthReusableView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import UIKit
#if os(iOS)
open class VCMonthReusableView: UICollectionReusableView {
    public static let identifier: String = "VCMonthReusableView"
    static var monthLabelColor: UIColor = .systemGray
    
    private let stackView = UIStackView()
    private var slotLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        slotLabels.forEach { $0.text = nil }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 스택뷰를 생성하여 7개의 슬롯(라벨)을 추가합니다.
    private func setupHeader() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        // 좌우 constant 제거하여 딱 붙게 설정
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for _ in 0..<7 {
            var label = UILabel()
            set(label: &label)
            slotLabels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    /// Month 모델을 받아 해당 달의 1일의 요일 슬롯에 "\(month.month)월" 텍스트를 표시합니다.
    open func update(with month: any VCMonth) {
        slotLabels[month.weekday(calendar: month.calendar) - 1].text = month.value
    }
    
    private func set(label: inout UILabel) {
        let device = UIDevice.current.userInterfaceIdiom
        label.textColor = VCMonthReusableView.monthLabelColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        
        if device == .phone {
            label.font = UIFont.preferredFont(forTextStyle: .body)
        } else if device == .pad {
            label.font = UIFont.preferredFont(forTextStyle: .title2)
        } else {
            label.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
}
#endif

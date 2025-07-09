import UIKit

/// 섹션 헤더 뷰로, 각 섹션(달)에 대해 상단에 해당 달을 표시합니다.
/// 내부에 7개의 슬롯(수평 스택뷰)이 있으며, Month 모델의 1일의 요일 인덱스에 해당하는 슬롯에 "\(month.month)월" 텍스트를 표시합니다.
class MyCalendarSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CalendarSectionHeaderView"
    
    private let stackView = UIStackView()
    private var slotLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHeader()
    }
    
    /// 스택뷰를 생성하여 7개의 슬롯(라벨)을 추가합니다.
    private func setupHeader() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // 좌우 constant 제거하여 딱 붙게 설정
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        for _ in 0..<7 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .systemGray2
            slotLabels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    
    /// Month 모델을 받아 해당 달의 1일의 요일 슬롯에 "\(month.month)월" 텍스트를 표시합니다.
    func update(with month: MyCalendarMonthModel) {
        slotLabels.forEach { $0.text = "" }
        guard let index = month.firstDayWeekdayIndex() else { return }
        if index < slotLabels.count {
            slotLabels[index].text = "\(month.month)월"
        }
    }
}

import UIKit

/// 화면 상단의 탑바 뷰 (년도와 월을 표시)
class MyCalendarTopBarView: UIView {
    private let titleLabel = UILabel()
    private let weekStackView = UIStackView()
    
    // UI
    static var topbarMainTitleFont: UIFont = .systemFont(ofSize: 24)
    static var topbarMainTitleColor: UIColor = .label
    static var saturdayColor: UIColor = .gray
    static var sundayColor: UIColor = .systemRed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    /// 탑바 뷰와 요일 스택뷰를 설정합니다.
    private func setupView() {
        // 년도/월 제목 레이블
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 요일을 균등하게 표시할 스택뷰
        weekStackView.axis = .horizontal
        weekStackView.distribution = .fillEqually
        addSubview(weekStackView)
        weekStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            weekStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            weekStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weekStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            weekStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            weekStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Calendar.current의 단축 요일을 이용하여 요일 레이블 추가
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        let weekdaySymbols = calendar.shortStandaloneWeekdaySymbols
        var index = 0
        for day in weekdaySymbols {
            let label = UILabel()
            if index == 0 {
                label.textColor = MyCalendarTopBarView.sundayColor
            } else if index == 6 {
                label.textColor = MyCalendarTopBarView.saturdayColor
            } else {
                label.textColor = .label
            }
            
            
            label.text = day
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            weekStackView.addArrangedSubview(label)
            index += 1
        }
        
        // title 설정
        let todayComponent = calendar.dateComponents([.year, .month], from: Date())
        titleLabel.text = "\(todayComponent.year ?? 2000)년 \(todayComponent.month ?? 1)월"
        titleLabel.font = MyCalendarTopBarView.topbarMainTitleFont
        titleLabel.textColor = MyCalendarTopBarView.topbarMainTitleColor
    }
    
    /// 상단 탑바의 제목을 "YYYY년 MM월" 형식으로 업데이트합니다.
    func updateTitle(year: Int, month: Int) {
        titleLabel.text = "\(year)년 \(month)월"
        titleLabel.font = MyCalendarTopBarView.topbarMainTitleFont
        titleLabel.textColor = MyCalendarTopBarView.topbarMainTitleColor
        
    }
}

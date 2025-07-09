import UIKit
import SnapKit

protocol MyCalendarDayCellDelegate: AnyObject {
    func calendarDayCellDidTapEvent(_ cell: CalendarDayCell, day: MyCalendarDayModel?)
}

/// 달력의 각 날짜 셀을 표시하는 뷰입니다.
class CalendarDayCell: UICollectionViewCell {
    static let reuseIdentifier = "CalendarDayCell"
    
    static var defaultDayLabelColor: UIColor = .black
    static var sundayColor: UIColor = .red
    static var saturdayColor: UIColor = .blue
    static var lineColor: UIColor = .lightGray  // 셀 내부 선의 컬러
    
    private let dayLabel = UILabel()
    private let eventView = UIView()
    private let eventLabel = UILabel()  // 이벤트 정보를 표시할 라벨
    private let topBorder = UIView()
    
    private var day: MyCalendarDayModel?
    private let calendar = Calendar.current
    
    /// eventLabel의 너비 제약 (이벤트가 여러 날짜에 걸칠 경우 확장)
    private var eventLabelWidthConstraint: NSLayoutConstraint!
    
    var delegate: MyCalendarDayCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        layoutConfigure()
    }
    
    /// 셀 내부의 dayLabel(상단에 배치, 위 여백 8pt), eventLabel(그 아래, 위 여백 4pt, 높이 20pt),
    /// 그리고 상단 선(topBorder)을 설정합니다.
    private func setupCell() {
        // topBorder: 상단에 배치
        contentView.addSubview(topBorder)
        topBorder.backgroundColor = CalendarDayCell.lineColor
        
        // dayLabel: 상단에 배치 (여백 8pt)
        contentView.addSubview(dayLabel)
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 16)

        
        // eventLabel: dayLabel 아래에 여백 4pt, 높이 20pt, 기본 너비는 셀 전체 폭
        contentView.addSubview(eventView)
        eventView.addSubview(eventLabel)
        eventLabel.textAlignment = .left
        eventLabel.font = UIFont.systemFont(ofSize: 10)
        eventLabel.backgroundColor = .clear
        eventLabel.isHidden = true
        
        // 이벤트 뷰 만들기
        eventView.isUserInteractionEnabled = true
        eventView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        eventView.isHidden = true
    }
    
    private func layoutConfigure() {
        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(contentView).inset(8)
        }
        
        eventView.snp.makeConstraints { make in
            make.leading.width.equalTo(contentView)
            make.top.equalTo(dayLabel).inset(25)
            make.height.equalTo(20)
        }
        
        eventLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(eventView)
            make.leading.equalTo(eventView).inset(10)
            make.trailing.equalTo(eventView)
        }
    }
    
    /// 주어진 Day 모델에 따라 셀을 업데이트합니다.
    /// 만약 해당 날짜에 등록된 이벤트가 단일 날짜이면 기존처럼 표시하고,
    /// 이벤트가 여러 날에 걸쳐 있다면(즉, startDate와 endDate가 다르면) 이벤트 라벨의 너비를 늘려 현재 셀에서 이벤트 시작일에만 표시합니다.
    func configure(with day: MyCalendarDayModel) {
        self.day = day
        if day.isWithinDisplayedMonth {
            let dayComponent = calendar.component(.day, from: day.date)
            dayLabel.text = "\(dayComponent)"
            let weekday = calendar.component(.weekday, from: day.date)
            if weekday == 1 {
                dayLabel.textColor = CalendarDayCell.sundayColor
            } else if weekday == 7 {
                dayLabel.textColor = CalendarDayCell.saturdayColor
            } else {
                dayLabel.textColor = CalendarDayCell.defaultDayLabelColor
            }
            
            
            
            topBorder.isHidden = false
            
            // 이벤트 추가
            eventManagement(day: day, weekday: weekday, dayComponent: dayComponent)
            
            if day.isToday {
                self.backgroundColor = .blue.withAlphaComponent(0.1)
            } else {
                self.backgroundColor = .clear
            }
            
        } else {
            dayLabel.text = ""
            eventLabel.text = ""
            eventView.isHidden = true
            eventLabel.isHidden = true
            topBorder.isHidden = true
            self.backgroundColor = .clear
        }
    }
    
    private func eventManagement(day: MyCalendarDayModel, weekday: Int, dayComponent: Int) {
        // 이벤트 표시: read 이벤트 기능 사용
        guard let event = day.event else {
            eventView.isHidden = true
            eventLabel.isHidden = true
            return
        }
        
        eventView.isHidden = false
        eventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEventTap)))
        
        if event.eventAtStartDate || weekday == 1 || dayComponent == 1 {
            guard let multiplied = day.rightPlaceToPutLabel() else {return}
            eventLabel.text = event.title
            eventLabel.isHidden = false
            eventLabel.snp.makeConstraints { make in
                make.width.equalTo(contentView).multipliedBy(multiplied).inset(8)
            }
        }
    }
    
    @objc func handleEventTap() {
        delegate?.calendarDayCellDidTapEvent(self, day: self.day)
    }
}

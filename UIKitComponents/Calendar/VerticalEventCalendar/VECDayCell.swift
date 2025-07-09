//
//  VECDayCell.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//

import UIKit
internal import Then
internal import SnapKit
internal import RxSwift
internal import RxGesture

protocol VECDayCellDelegate {
    func didEventTap(event: VECEvent)
}

final class VECDayCell: UICollectionViewCell {
    private var disposeEventTap: Disposable?
    static let reuseIdentifier = "VECDayCell"
    static var weekdayTextColor: UIColor = .label
    static var saturdayTextColor: UIColor = .systemGray2
    static var sundayTextColor: UIColor = .systemRed
    static var cellBorderColor: UIColor = .systemGray6
    
    var delegate: VECDayCellDelegate?
    
    private let dayLabel = UILabel().then {
        $0.isHidden = true
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .label
    }
    private let topBorder = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = VECDayCell.cellBorderColor
    }
    
    private var eventViews: [UIView] = []
    private var eventLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setUP()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        parpareViews()
    }
    
    private func parpareViews() {
        dayLabel.text = nil
        dayLabel.textColor = .label
        dayLabel.isHidden = true
        topBorder.isHidden = true
        disposeEventTap?.dispose()
        disposeEventTap = nil
        
        // Event
        resetAllEventViews()
    }
    
    private func resetAllEventViews() {
        // 모든 이벤트 뷰 및 라벨 초기화
        for (index, eventView) in eventViews.enumerated() {
            // 이벤트 뷰 초기화
//            eventView.isHidden = true
            eventView.backgroundColor = .clear
            eventView.layer.cornerRadius = 0
            eventView.layer.maskedCorners = []
            
            // 이벤트 뷰의 모든 제약조건 제거
            eventView.snp.removeConstraints()
            
            // 이벤트 라벨 초기화
            let eventLabel = eventLabels[index]
            eventLabel.text = nil
            eventLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        addSubview(topBorder)
        addSubview(dayLabel)
    }
    private func setUP() {
        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
    }
    
    func configure(model: VECDay) {
        if model.isEmptyDate { return }
        topBorder.isHidden = false
        dayLabel.isHidden = false
        dayLabel.text = model.date.day.description
        dayColor(model: model)
        setupEvents(for: model)
    }
    
    
    
    private func dayColor(model: VECDay) {
        if model.isSaturday {
            dayLabel.textColor = VECDayCell.saturdayTextColor
        } else if model.isSunday {
            dayLabel.textColor = VECDayCell.sundayTextColor
        } else {
            dayLabel.textColor = VECDayCell.weekdayTextColor
        }
    }
}

// MARK: - Event Function
extension VECDayCell {
    private func setupEvents(for day: VECDay) {
        guard !day.events.isEmpty else { return }
        createEventComponents(count: 4)
        
        for event in day.events {
            guard let event else { continue }
            
            let (value, multiple) = event.setEventUI(day.date)
            
            setupEventView(
                at: event.locationNumber,
                with: event,
                when: day.date,
                showLabel: value,
                multiple: CGFloat(multiple)
            )
        }
    }
    
    private func setupEventView(at index: Int, with event: VECEvent, when day: Date, showLabel: Bool, multiple: CGFloat) {
        guard index < eventViews.count else { return }
        
        let eventView = eventViews[index]
        let eventLabel = eventLabels[index]
        
        // 이벤트 뷰 설정
        // 이벤트 라벨 설정
        eventLabel.isHidden = !showLabel
        if showLabel {
            eventView.backgroundColor = event.color.withAlphaComponent(0.2)
            eventLabel.text = event.title
            eventLabel.textColor = event.color
        }
        
        // 코너 라운드 설정.
        applyCornerRadius(to: eventView, isStartDate: event.isStartDateExsistInThisWeek(day.date), isEndDate: event.isEndDateExsistInThisWeek(day.date))
        
        // 레이아웃 적용
        applyLayout(for: eventView, at: index, multiple: CGFloat(multiple))
        
        //
        buildTabFunctionInEventView(eventView, event: event)
        
    }
    
    private func createEventComponents(count: Int) {
        let eventHeight: CGFloat = contentView.bounds.height * 0.15
        for i in 0..<count {
            // 이벤트 뷰 생성
            let eventView = UIView()
            eventView.clipsToBounds = true
            eventView.isUserInteractionEnabled = true
            eventView.backgroundColor = .clear
            contentView.addSubview(eventView)
            eventViews.append(eventView)
            
            if i == 0 {
                eventViews[i].snp.makeConstraints { make in
                    make.top.equalTo(dayLabel.snp.bottom).offset(15)
                    make.height.equalTo(eventHeight)
                }
            } else {
                eventViews[i].snp.makeConstraints { make in
                    make.top.equalTo(eventViews[i - 1].snp.bottom)
                    make.height.equalTo(eventHeight)
                }
            }
            
            // 이벤트 라벨 생성
            let eventLabel = UILabel()
            eventLabel.textAlignment = .left
            eventLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
            eventLabel.textColor = .black
            eventLabel.numberOfLines = 1
            eventLabel.lineBreakMode = .byTruncatingTail
            eventLabel.adjustsFontSizeToFitWidth = false
            eventLabel.isHidden = true
            eventView.addSubview(eventLabel)
            eventLabels.append(eventLabel)
            
            // 라벨 제약조건 설정
            eventLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 1))
            }
        }
    }
}

// MARK: - reUsable Function
extension VECDayCell {
    // MARK: - 이벤트 탭 버튼 기능 구현.
    private func buildTabFunctionInEventView(_ view: UIView, event: VECEvent) {
        let disposable = view.rx.tapGesture()
            .when(.ended)
            .bind { [weak self] _ in
                guard let self else { return }
                self.delegate?.didEventTap(event: event)
            }
        
        disposeEventTap = disposable
    }
    
    
    // MARK: - 코너 라디우스 적용
    private func applyCornerRadius(to view: UIView, isStartDate: Bool, isEndDate: Bool) {
        let radius: CGFloat = 4
        view.layer.masksToBounds = true
        
        if isStartDate && isEndDate {
            // 단일 날짜 이벤트 (모든 코너 둥글게)
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else if isStartDate {
            // 시작일 (왼쪽 코너만 둥글게)
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if isEndDate {
            // 종료일 (오른쪽 코너만 둥글게)
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            // 중간 날짜 (코너 없음)
            view.layer.cornerRadius = 0
            view.layer.maskedCorners = []
        }
    }
    
    // MARK: - 레이아웃 적용
    private func applyLayout(for eventView: UIView, at index: Int, multiple: CGFloat) {
        let topOffset: CGFloat = contentView.bounds.height * 0.1 // 첫 번째 이벤트와 날짜 레이블 사이 간격
        let spacing: CGFloat = 1 // 이벤트 간 간격
        let eventHeight: CGFloat = contentView.bounds.height * 0.15 // 이벤트 높이
        
        eventView.snp.remakeConstraints { make in
            // 수직 위치 설정
            if index == 0 {
                make.top.equalTo(dayLabel.snp.bottom).offset(topOffset)
            } else if index > 0 && index < eventViews.count {
                make.top.equalTo(eventViews[index-1].snp.bottom).offset(spacing)
            }
            
            // 수평 위치 및 크기 설정
            make.leading.equalTo(contentView)
            make.height.equalTo(eventHeight)
            
            // 이벤트가 여러 날에 걸쳐 있는 경우 너비 조정
            if multiple > 1.0 {
                // 셀 너비의 multiple 배로 설정
                make.width.equalTo(contentView.snp.width).multipliedBy(multiple).inset(1.5)
            } else {
                // 일반 이벤트는 셀 너비와 동일하게
                make.trailing.equalTo(contentView)
            }
        }
    }
}

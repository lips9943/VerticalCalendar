//
//  VEC.swift
//  UIKitComponents
//
//  Created by 고혁준 on 4/21/25.
//
import UIKit
internal import SnapKit


public protocol VECDelegate {
    func onEventTapped(event: Event)
}

open class VerticalEventCalendar: UIView {
    private(set) var viewModel: VECViewModel!
    private(set) var collectionView: VECCollectionView!
    private(set) var topWeekDayView: VECTopWeekDayView!
    private(set) var topYearView: VECTopYearView!
    private(set) var layout: VECLayout!
    private(set) var locale: Locale!
    
    public var delegate: VECDelegate?
    
    var currentYear: Int = 0
    var isStarted: Bool = false
    // MARK: - Public Values
    
    // MARK: - Customize UI
    public var mainBGColor: UIColor = .white {
        didSet {
            collectionView.backgroundColor = mainBGColor
            topWeekDayView.backgroundColor = mainBGColor
        }
    }
    public var monthHeaderTextColor: UIColor = .systemGray2 {
        didSet { VECReusableMonth.monthLabelColor = monthHeaderTextColor }
    }
    public var yearTextColor: UIColor = .white {
        didSet { topYearView.textColor = yearTextColor }
    }
    public var weekdayTextColor: UIColor = .label {
        didSet {
            VECDayCell.weekdayTextColor = weekdayTextColor
            topWeekDayView.weekDayLabelColor = weekdayTextColor
        }
    }
    public var saturdayTextColor: UIColor = .systemGray2 {
        didSet {
            VECDayCell.saturdayTextColor = saturdayTextColor
            topWeekDayView.saturdayLabelColor = saturdayTextColor
        }
    }
    public var sundayTextColor: UIColor = .systemGray2 {
        didSet {
            VECDayCell.sundayTextColor = sundayTextColor
            topWeekDayView.sundayLabelColor = sundayTextColor
        }
    }
    public var topBorderColor: UIColor = .systemGray6 {
        didSet { VECDayCell.cellBorderColor = topBorderColor }
    }
    public var todayCellColor: UIColor = .systemRed.withAlphaComponent(0.1) {
        didSet {
            VECDayCell.todayCellColor = todayCellColor
        }
    }
    public var topBorderThickness: CGFloat = 1 {
        didSet { VECDayCell.topBorderThickness = topBorderThickness }
    }
    
    public init(startDate: Date = Date(), locale: Locale = Locale.current) {
        self.locale = locale
        layout = VECLayout()
        collectionView = VECCollectionView()
        viewModel = VECViewModel(
            collectionView: collectionView,
            startDate: startDate)
        topWeekDayView = VECTopWeekDayView(locale: locale)
        topYearView = VECTopYearView()
        
        super.init(frame: .zero)
        setCollectionView()
        addView()
        setAllLayouts()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        addSubview(collectionView)
        addSubview(topWeekDayView)
        addSubview(topYearView)
    }
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bouncesVertically = false
        collectionView.showsVerticalScrollIndicator = true
    }
    private func setAllLayouts() {
        let topInset: CGFloat = 30
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.collectionViewLayout = layout.createLayout()
        collectionView.topInset = topInset
        topWeekDayView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(topInset)
        }
        
        topYearView.snp.makeConstraints { make in
            make.top.equalTo(topWeekDayView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
    }
}

// MARK: - IndexPath
extension VerticalEventCalendar {
    public func moveScrollToCurrentMonthSection(setToLastWeekOfPrevMonth: Bool = true) {
        Task {
            await viewModel.moveScrollToCurrentMonthSection(by: Date.now, setPrev: setToLastWeekOfPrevMonth)
        }
    }
    
    public func moveScrollToCurrentDateCell(setToPrevWeek: Bool = true) {
        Task {
            await viewModel.moveScrollToCurrentDateCell(by: Date.now, setPrev: setToPrevWeek)
        }
        
    }
}

// MARK: - Event Handling
extension VerticalEventCalendar {
    public func add(event: Event) {
        Task {
            await viewModel.add(event: event)
        }
    }
    public func add(events: [Event]) {
        Task {
            await viewModel.add(events: events)
        }
    }
    public func deleteEvent(by id: String) {
        Task {
            guard let indexPaths = await viewModel.deleteEvent(by: id) else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: indexPaths)
            }
        }
    }
}





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

open class VEC: UIView {
    private(set) var viewModel: VECViewModel!
    private(set) var collectionView: VECCollectionView!
    private(set) var topWeekDayView: VECTopWeekDayView!
    private(set) var topYearView: VECTopYearView!
    private(set) var layout: VECLayout!
    private(set) var indexPath: IndexPath?
    
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
    
    public init(startDate: Date = Date(), events: [Event]) {
        layout = VECLayout()
        viewModel = VECViewModel(startDate: startDate, events: VECEvent.convert(from: events))
        collectionView = VECCollectionView()
        topWeekDayView = VECTopWeekDayView()
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
    
    public func scrollToCurrentIndexPath(animated: Bool = false) {
        guard let indexPath else { return }
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: animated)
    }
}

// MARK: - IndexPath
extension VEC {
    public func setOffsetToCurrentMonthSection(setToLastWeekOfPrevMonth: Bool = true) {
        guard let indexPath = viewModel.findMonthIndexPath(by: Date.now, setPrev: setToLastWeekOfPrevMonth) else { return }
        self.indexPath = indexPath
    }
    
    public func setOffsetToCurrentDateCell(setToPrevWeek: Bool = true) {
        guard let indexPath = viewModel.findCellIndexPath(by: Date.now, setPrev: setToPrevWeek) else { return }
        self.indexPath = indexPath
    }
}

// MARK: - Event Handling
extension VEC {
    public func addEvent(event: Event) {
        
        viewModel.addEvent(event: event, collectionView: collectionView)
    }
    public func deleteEvent(id: String) {
        guard let indexPaths = viewModel.deleteEvent(id: id) else { return }
        collectionView.reloadItems(at: indexPaths)
    }
}





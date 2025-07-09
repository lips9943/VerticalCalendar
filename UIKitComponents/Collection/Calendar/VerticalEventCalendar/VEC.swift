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
    
    public var delegate: VECDelegate?
    
    var currentYear: Int = 0
    var isStarted: Bool = false
    
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
    public var cellBorderColor: UIColor = .systemGray6 {
        didSet { VECDayCell.cellBorderColor = cellBorderColor }
    }
    public var todayCellColor: UIColor = .systemRed.withAlphaComponent(0.1) {
        didSet {
            VECDayCell.todayCellColor = todayCellColor
        }
    }

    
    public override init(frame: CGRect) {
        layout = VECLayout()
        viewModel = VECViewModel(startDate: "2015-02-03".toDate()!.date)
        collectionView = VECCollectionView()
        topWeekDayView = VECTopWeekDayView()
        topYearView = VECTopYearView()
        
        super.init(frame: frame)
        setCollectionView()
        addView()
        setAllLayouts()
        toCurrentPosition()
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
    private func toCurrentPosition() {
        guard let indexPath = viewModel.findTodaysIndexPath() else { return }
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        }
    }
    
    
}
// MARK: - Event Handling
extension VEC {
    public func addEvent(event: Event) {
        viewModel.addEvent(event: event, collectionView: collectionView)
    }
    public func deleteEvent(id: UUID) {
        guard let indexPaths = viewModel.deleteEvent(id: id) else { return }
        collectionView.reloadItems(at: indexPaths)
    }
}





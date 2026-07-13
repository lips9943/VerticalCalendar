//
//  VerticalCalendar.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 8/18/25.
//
import UIKit
import Hero

#if os(iOS)
open class VCalendar: UICollectionViewController {
    private var isResetScroll: Bool = false
    private var yearview: VCYearView!
    private var weekdayView: VCWeekDayView!
    private var loadingView = VCLoadingView()
    
    public var isWeekdayViewAble: Bool = true {
        didSet {
            if isWeekdayViewAble {
                guard weekdayView == nil else { return }
                setDefaultWeekdayView()
            } else {
                guard weekdayView != nil else { return }
                weekdayView.removeFromSuperview()
            }
        }
    }
    
    public var isYearViewAble: Bool = true {
        didSet {
            if isYearViewAble {
                guard yearview == nil else { return }
                setDefaultYearView()
            } else {
                guard yearview != nil else { return }
                yearview.removeFromSuperview()
            }
        }
    }
    
    public typealias ViewModel = any VCViewModel
    open var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: Self.createCompositionalLayout())
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.hero.isEnabled = true
        self.view.hero.id = "calendar"
        self.collectionView.register(VCDayCell.self, forCellWithReuseIdentifier: VCDayCell.reuseIdentifier)
        self.collectionView.register(VCMonthReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VCMonthReusableView.identifier)
        setDefaultYearView()
        setDefaultWeekdayView()
        setActivityIndicator()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor
    private func setScrollAtToday(animated: Bool = false) {
        guard let indexPath = self.viewModel.indexManager.findToday(in: self.viewModel.calendars) else { return }
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: animated)
    }
    
    @MainActor
    private func moveScrollAtMonthIndex(_ index: Int, animated: Bool = false) {
        let lastIndex = viewModel.calendars[index].days.endIndex - 1
        let indexPath = IndexPath(item: lastIndex, section: index)
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: animated)
    }
}


// MARK: - Data Source
extension VCalendar {
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.calendars.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.calendars[section].days.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCDayCell.reuseIdentifier, for: indexPath) as? VCDayCell else { return UICollectionViewCell() }
        let day = viewModel.calendars[indexPath.section].days[indexPath.item]
        cell.configure(day: day)
        return cell
    }
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: VCMonthReusableView.identifier,
                                                                         for: indexPath) as? VCMonthReusableView else { return UICollectionReusableView() }
        let month = viewModel.calendars[indexPath.section].month
        view.update(with: month)
        return view
    }
}


// MARK: - Custom View Features
extension VCalendar {
    private func setDefaultYearView() {
        self.yearview = VCYearView()
        self.yearview.configure(self.view)
    }
    
    private func setDefaultWeekdayView() {
        self.weekdayView = VCWeekDayView()
        view.addSubview(weekdayView)
        weekdayView.configure(with: view)
    }
    
    /// Year view appears when first or last month stuck on the View
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let calendar = viewModel.calendars[indexPath.section]
        guard let month = calendar.month.date.month, (month == 1 || month == 12) else { return }
        let halfOfDayIndex = calendar.days.count / 2
        if indexPath.row == halfOfDayIndex {
            self.yearview.update(with: calendar.month.date)
        }
    }
}

// MARK: - Managing Loading
extension VCalendar {
    public var isLoading: Bool {
        get { loadingView.isLoading }
        set {
            guard loadingView.isLoading != newValue else { return }
            if newValue {
                loadingView.startLoading()
            } else {
                loadingView.stopLoading()
            }
        }
    }
    
    private func setActivityIndicator() {
        self.loadingView.configure(calendar: self)
    }
}

// MARK: - VCMonthSelectionViewController Delegate
extension VCalendar: VCMonthSelectionViewControllerDelegate {
    public func getIndexOfMonth(date: Date, viewModelIndex index: Int) {
        let monthIndex = index != 0 ? index - 1 : index
        moveScrollAtMonthIndex(monthIndex)
        yearview.update(with: date)
    }
    
    @MainActor
    public func presentMonthSelectionVC(cellType: VCMonthSelectionCell.Type = VCMonthSelectionCell.self) {
        let visibleIndexes = self.collectionView.indexPathsForVisibleItems
        guard !visibleIndexes.isEmpty else { return }
        let index: Int = visibleIndexes.count / 2
        let visibleIndexPath = visibleIndexes[index]
        let monthDate = viewModel.calendars[visibleIndexPath.section].month.date
        let vc = VCMonthSelectionViewController(viewModel: viewModel, nearDate: monthDate)
        vc.delegate = self
        vc.collectionView.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.hero.isEnabled = true
        nvc.hero.modalAnimationType = .fade
        nvc.modalPresentationStyle = .fullScreen
        
        self.present(nvc, animated: true)
    }
}

// MARK: - Layout
extension VCalendar {
    fileprivate static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let collectionHeight = UIScreen.main.bounds.height
        let rows: CGFloat = 6
        let headerHeight: CGFloat = 30
        let gridHeight: CGFloat = collectionHeight - headerHeight
        let itemHeight: CGFloat = gridHeight / rows
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/7.0),
                                              heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item, count: 7)
        
        let sectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(itemHeight * rows))
        let sectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: sectionGroupSize,
                                                            repeatingSubitem: group,
                                                            count: Int(rows))
        
        let section = NSCollectionLayoutSection(group: sectionGroup)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension VCalendar {
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        guard y < 0, !isResetScroll else { return }
        let date = Date()
        isResetScroll = true
        
        Task {
            self.setScrollAtToday()
            yearview.update(with: date)
            try await Task.sleep(for: .seconds(2))
            isResetScroll = false
        }
    }
}
#endif

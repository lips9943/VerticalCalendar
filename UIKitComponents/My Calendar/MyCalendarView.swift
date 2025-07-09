import UIKit
import SnapKit

protocol MyCalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: MyCalendarView, _ cell: CalendarDayCell, day: MyCalendarDayModel)
}
/// 달력을 표시하는 메인 뷰입니다.
class MyCalendarView: UIView {
    var startDate: Date = Date() {
        didSet {
            reloadDataAndScrollToCurrentMonth()
        }
    }
    
    var theme: MyCalendarTheme = .default {
        didSet {
            self.backgroundColor = theme.backgroundColor
            collectionView.backgroundColor = theme.backgroundColor
            CalendarDayCell.defaultDayLabelColor = theme.dayLabelColor
            CalendarDayCell.sundayColor = theme.sundayColor
            CalendarDayCell.saturdayColor = theme.saturdayColor
            CalendarDayCell.lineColor = theme.cellLineColor
            collectionView.reloadData()
        }
    }
    
    private let topBarView = MyCalendarTopBarView()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<MyCalendarMonthModel, MyCalendarDayModel>!
    
    private var months: [MyCalendarMonthModel] = []
    private let calendarManager = MyCalendarManager()
    private let eventManager = MyCalendarEventManager.shared
    
    var delegate: MyCalendarViewDelegate?
    
    init() {
        super.init(frame: .zero)
        collectionViewSetup()
        setupViews()
        configureDataSource()
        startDate = Date()
        theme = .default
        reloadDataAndScrollToCurrentMonth()
        NotificationCenter.default.addObserver(self, selector: #selector(handleEventsUpdated), name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewSetup()
        setupViews()
        configureDataSource()
        startDate = Date()
        theme = .default
        reloadDataAndScrollToCurrentMonth()
        NotificationCenter.default.addObserver(self, selector: #selector(handleEventsUpdated), name: MyCalendarEventManager.eventsUpdatedNotification, object: nil)
    }
    
    /// views Layout
    private func setupViews() {
        // TopBarView Layout
        addSubview(topBarView)
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        // collectionView Layout
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topBarView.snp.bottom)
        }
    }
    
    /// 콜랙션 뷰와 셀 register
    private func collectionViewSetup() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.reuseIdentifier)
        collectionView.register(MyCalendarSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyCalendarSectionHeaderView.reuseIdentifier)
        collectionView.backgroundColor = theme.backgroundColor
        collectionView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout = createLayout()
    }
    
    @objc private func handleEventsUpdated() {
        reloadDataAndScrollToCurrentMonth()
    }
}

// MARK: - Layout 관련 메서드
extension MyCalendarView {
    private func createLayout() -> UICollectionViewLayout {
        let collectionHeight = self.bounds.height - 10
        let headerHeight: CGFloat = 30
        let gridHeight = collectionHeight - headerHeight
        let rows: CGFloat = 6
        let itemHeight = gridHeight / rows
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/7.0),
                                              heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 7)
        
        let sectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(itemHeight * rows))
        let sectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: sectionGroupSize, repeatingSubitem: group, count: Int(rows))
        
        let section = NSCollectionLayoutSection(group: sectionGroup)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data 관련 메서드 및 초기 스크롤/동적 로딩 처리
extension MyCalendarView {
    private func reloadDataAndScrollToCurrentMonth() {
        months = calendarManager.generateMonths(startDate: startDate)
        var snapshot = NSDiffableDataSourceSnapshot<MyCalendarMonthModel, MyCalendarDayModel>()
        for month in months {
            let currentMonth = putEventsInDays(month)
            snapshot.appendSections([currentMonth])
            snapshot.appendItems(currentMonth.days, toSection: currentMonth)
        }
        dataSource.apply(snapshot, animatingDifferences: false) {
            let currentComponents = Calendar.current.dateComponents([.year, .month], from: Date())
            if let targetIndex = self.months.firstIndex(where: { $0.year == currentComponents.year && $0.month == currentComponents.month }) {
                let indexPath = IndexPath(item: 0, section: targetIndex)
                DispatchQueue.main.async {
                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                }
            }
        }
    }
    
    // 겹치는 달과 일을 찾아 event를 day안에 추가합니다.
    private func putEventsInDays(_ month: MyCalendarMonthModel) -> MyCalendarMonthModel {
        var currentMonth = month
        var index = 0

        // day로 이벤트를 불러오고, 이벤트가 존재한다면, 현재 일을 바꾸고 인덱스에 재할당
        for day in month.days {
            guard let event = eventManager.event(for: day.date) else {
                index += 1
                continue
            }
            
            currentMonth.days[index].event = event
            index += 1
        }
        
        return currentMonth
    }
    
    // 셀과 헤더를 설정.
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MyCalendarMonthModel, MyCalendarDayModel>(collectionView: collectionView) { (collectionView, indexPath, day) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCell.reuseIdentifier, for: indexPath) as! CalendarDayCell
            cell.delegate = self
            cell.configure(with: day)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyCalendarSectionHeaderView.reuseIdentifier, for: indexPath) as! MyCalendarSectionHeaderView
                if let month = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] {
                    header.update(with: month)
                }
                return header
            }
            return nil
        }
    }
    
    
    
}

// MARK: - UICollectionViewDelegate (스크롤 시 topBar 업데이트 및 동적 로딩)
extension MyCalendarView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout,
              let attributesArray = layout.layoutAttributesForElements(in: collectionView.bounds) else { return }
        
        let offsetY = scrollView.contentOffset.y
        
        // 1) 화면에 들어온 헤더만 필터링
        let visibleHeaders = attributesArray
            .filter { $0.representedElementKind == UICollectionView.elementKindSectionHeader }
            // 헤더 frame이 현재 화면(bounds)과 어느 정도 겹치는지 확인
            .filter { $0.frame.maxY >= offsetY && $0.frame.minY <= offsetY + (collectionView.bounds.height / 2) }
            // ↑ maxY가 offsetY보다 크고, minY가 offsetY + 화면높이보다 작으면 (즉, 화면과 겹치면) visible하다고 볼 수 있음
        
        // 2) 화면 상단에 가장 가까운 헤더(즉, minY가 가장 작은 것) 하나 뽑기
        guard let topHeader = visibleHeaders.max(by: { $0.frame.minY < $1.frame.minY }) else { return }
        
        // 3) 해당 헤더의 섹션으로부터 Month 정보를 가져오기
        let currentMonth = dataSource.snapshot().sectionIdentifiers[topHeader.indexPath.section]
        
        // 4) topBar 갱신
        topBarView.updateTitle(year: currentMonth.year, month: currentMonth.month)
        
        // 5) 마지막 부근에 도달하면 다음 달 정보 로드
        if collectionView.contentOffset.y + collectionView.bounds.height >= collectionView.contentSize.height - 70 {
            loadNextMonthIfNeeded()
        }
    }
    
    private func loadNextMonthIfNeeded() {
        guard let lastMonth = months.last,
              let month = calendarManager.generateNextMonth(after: lastMonth) else { return }
        let newMonth = putEventsInDays(month)
        months.append(newMonth)
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([newMonth])
        snapshot.appendItems(newMonth.days, toSection: newMonth)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: - Cell Delegate
extension MyCalendarView: MyCalendarDayCellDelegate {
    func calendarDayCellDidTapEvent(_ cell: CalendarDayCell, day: MyCalendarDayModel?) {
        guard let day else { return }
        self.delegate?.calendarView(self, cell, day: day)
    }
}

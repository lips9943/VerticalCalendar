//
//  VCYearSelectionViewController.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/19/26.
//
import UIKit

protocol VCMonthSelectionViewControllerDelegate {
    func getIndexOfMonth(date: Date, viewModelIndex index: Int)
}

class VCMonthSelectionViewController: UICollectionViewController {
    typealias ViewModel = any VCViewModel
    private var viewModel: ViewModel
    
    var delegate: VCMonthSelectionViewControllerDelegate?
    
    private var monthForYears: [[Date]] = []
    private let scrollToIndex: IndexPath
    
    init(viewModel: ViewModel, nearDate: Date? = nil) {
        self.viewModel = viewModel
        
        //
        var currentYear: Date?
        var monthes: [Date] = []
        let monthesForLoop = viewModel.calendars.map { $0.month }
        for month in monthesForLoop {
            let date = month.date
            
            if let cleanCurrentYear = currentYear, date.year != cleanCurrentYear.year {
                monthForYears.append(monthes)
                monthes.removeAll()
                currentYear = date
            } else {
                currentYear = date
            }
            
            monthes.append(month.date)
        }
        
        var scrollToIndex: IndexPath = .init(item: 0, section: 0)
        if let nearDate, let year = nearDate.year, let yi = monthForYears.firstIndex(where: { $0.first?.year == year }) {
            let index = yi <= 0 ? 0 : yi - 1
            let mi = monthForYears[index].count - 1
            scrollToIndex = .init(item: mi, section: index)
        }
        
        self.scrollToIndex = scrollToIndex
        super.init(collectionViewLayout: VCMonthSelectionViewController.layout)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(MonthSelectionCell.self, forCellWithReuseIdentifier: MonthSelectionCell.cellReuseID)
        self.collectionView.register(YearView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: YearView.reuseId)
        self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.collectionView.scrollToItem(at: scrollToIndex, at: .top, animated: false)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
}

// MARK: - Data Source
extension VCMonthSelectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        monthForYears.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthForYears[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthSelectionCell.cellReuseID, for: indexPath) as? MonthSelectionCell else { return UICollectionViewCell() }
        let month = monthForYears[indexPath.section][indexPath.item]
        cell.configure(date: month, calendar: viewModel.calendarManager.calendar)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: YearView.reuseId, for: indexPath) as? YearView else { return UICollectionReusableView() }
        guard let year = monthForYears[indexPath.section].first else { return view }
        view.configure(date: year)
        return view
    }
}

// MARK: - Delegate
extension VCMonthSelectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate else { return }
        guard indexPath.section < monthForYears.count, indexPath.item < monthForYears[indexPath.section].count else { return }
        let month = monthForYears[indexPath.section][indexPath.item]
        let index = viewModel.calendars.firstIndex { $0.month.date == month }
        guard let index else { print("Delegate of MonthSelectionViewController: Index of month not found"); return }
        dismiss(animated: true)
        delegate.getIndexOfMonth(date: month, viewModelIndex: index)
    }
}

// MARK: - Layout
extension VCMonthSelectionViewController {
    private static var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: size.width / 3.3, height: size.height / 10)
        layout.headerReferenceSize = CGSize(width: size.width, height: size.height / 10)
        return layout
    }
}

// MARK: - Su
extension VCMonthSelectionViewController {
    class YearView: UICollectionReusableView {
        static var reuseId: String { "yearSelection-identifier" }
        private var yearLabel: UILabel!
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setYearLabel()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func prepareForReuse() {
            self.yearLabel.text = nil
        }
        
        private func setYearLabel() {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .title1)
            label.numberOfLines = 1
            label.textColor = .label
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            
            yearLabel = label
            
            addSubview(label)
            
            NSLayoutConstraint.activate([
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        func configure(date: Date) {
            guard let year = date.year else { return }
            yearLabel.text = "\(year)"
        }
    }
}
// MARK: - Cell
extension VCMonthSelectionViewController {
    class MonthSelectionCell: UICollectionViewCell {
        private var monthLabel: UILabel!
        
        static var cellReuseID: String { "yearSelectionCell-identifier" }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentViewSetup()
            setMonthLabel()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func prepareForReuse() {
            super.prepareForReuse()
        }
        
        private func contentViewSetup() {
            let cv = self.contentView
            cv.backgroundColor = .secondarySystemBackground
            cv.layer.cornerRadius = 15
        }
        
        private func setMonthLabel() {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .preferredFont(forTextStyle: .title2)
            label.highlightedTextColor = .red
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            monthLabel = label
            
            self.contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
        
        private func update() {
            self.monthLabel.text = nil
            self.monthLabel.textColor = .label
        }
        
        func configure(date: Date, calendar: Calendar) {
            guard let month = date.month else { return }
            self.monthLabel.text = calendar.shortMonthSymbols[month - 1]
        }
    }
}


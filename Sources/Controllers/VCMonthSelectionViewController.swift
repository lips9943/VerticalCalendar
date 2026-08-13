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

public class VCMonthSelectionViewController: UICollectionViewController {
    typealias ViewModel = any VCViewModel
    private var viewModel: ViewModel
    
    var delegate: VCMonthSelectionViewControllerDelegate?
    
    private var monthForYears: [[Date]] = []
    private let scrollToIndex: IndexPath
    private let nearDate: Date?
    private var heroIndexPath: IndexPath?
    
    init(viewModel: ViewModel, nearDate: Date? = nil) {
        self.viewModel = viewModel
        self.nearDate = nearDate
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        hero.isEnabled = true
        self.collectionView.register(VCMonthSelectionYearReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VCMonthSelectionYearReusableView.reuseId)
        self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.collectionView.scrollToItem(at: scrollToIndex, at: .top, animated: false)
    }
    
    @objc func close() {
        if let heroIndexPath {
            let cell = self.collectionView.cellForItem(at: heroIndexPath) as? VCMonthSelectionCell
            cell?.prepareForReuse()
        }
        
        self.dismiss(animated: true)
    }
}

// MARK: - Data Source
extension VCMonthSelectionViewController {
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        monthForYears.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthForYears[section].count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section < monthForYears.count,
              indexPath.item < monthForYears[indexPath.section].count else { return UICollectionViewCell() }
        let month = monthForYears[indexPath.section][indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCMonthSelectionCell.identifier, for: indexPath) as? VCMonthSelectionCell,
              let calendarIndex = viewModel.indexManager.findIndex(ofMonth: month, in: viewModel.calendars) else { return UICollectionViewCell() }
        
        cell.configure(date: month, calendar: viewModel.calendars[calendarIndex])
        
        
        
        if nearDate == month {
            cell.hero.id = "calendar"
            heroIndexPath = indexPath
        }
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VCMonthSelectionYearReusableView.reuseId, for: indexPath) as? VCMonthSelectionYearReusableView else { return UICollectionReusableView() }
        guard let year = monthForYears[indexPath.section].first else { return view }
        view.configure(date: year)
        return view
    }
}

// MARK: - Delegate
extension VCMonthSelectionViewController {
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate else { return }
        guard indexPath.section < monthForYears.count, indexPath.item < monthForYears[indexPath.section].count else { return }
        let month = monthForYears[indexPath.section][indexPath.item]
        let index = viewModel.calendars.firstIndex { $0.month.date == month }
        guard let index else { print("Delegate of MonthSelectionViewController: Index of month not found"); return }
        dismiss(animated: true)
        delegate.getIndexOfMonth(date: month, viewModelIndex: index)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let willCell = collectionView.cellForItem(at: indexPath) as? VCMonthSelectionCell
        if let heroIndexPath, indexPath != heroIndexPath {
            let cell = collectionView.cellForItem(at: heroIndexPath)
            cell?.hero.id = nil
            
            willCell?.hero.id = "calendar"
        }
        
        willCell?.prepareForReuse()
        return true
    }
}

// MARK: - Layout
extension VCMonthSelectionViewController: UICollectionViewDelegateFlowLayout {
    private static var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: size.width / 3.4, height: size.height / 9)
        layout.headerReferenceSize = CGSize(width: size.width, height: size.height / 10)
        return layout
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: - Su
extension VCMonthSelectionViewController {
    class VCMonthSelectionYearReusableView: UICollectionReusableView {
        static var reuseId: String { "yearSelection-identifier" }
        private var yearLabel: UILabel!
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setYearLabel()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func prepareForReuse() {
            super.prepareForReuse()
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

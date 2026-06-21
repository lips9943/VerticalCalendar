//
//  MonthSelectionCell.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 6/21/26.
//

import UIKit

open class VCMonthSelectionCell: UICollectionViewCell {
    private var monthLabel: UILabel!
    
    static var cellReuseID: String { "yearSelectionCell-identifier" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentViewSetup()
        setMonthLabel()
    }
    
    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        update()
    }
    
    private func contentViewSetup() {
        let cv = self.contentView
        cv.backgroundColor = .secondarySystemBackground
        cv.layer.cornerRadius = 15
    }
    
    private func setMonthLabel() {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .headline)
        label.highlightedTextColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel = label
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        ])
    }
    
    private func update() {
        self.monthLabel.text = nil
        self.monthLabel.textColor = .label
    }
    
    public func configure(date: Date, calendar: Calendar) {
        guard let month = date.month else { return }
        self.monthLabel.text = calendar.shortMonthSymbols[month - 1]
    }
}

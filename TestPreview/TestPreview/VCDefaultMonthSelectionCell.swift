//
//  VCDefaultMonthSelectionCell.swift
//  TestPreview
//
//  Created by 고혁준 on 6/20/26.
//

import VerticalCalendar
import UIKit

final class VCDefaultMonthSelectionCell: VCMonthSelectionCell {
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
    }
    
    @MainActor required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setImageView() {
        let iv = UIImageView()
        self.imageView = iv
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iv)
        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: contentView.topAnchor),
            iv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func configure(date: Date, calendar: any VCCalendar) {
        super.configure(date: date, calendar: calendar)
        guard let calendar = calendar as? VCDefaultCalendar,
              let randomDay = calendar.days.filter({ $0.image != nil }).randomElement() else { return }
        imageView.image = randomDay.image
    }
}

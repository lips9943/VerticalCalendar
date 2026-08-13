//
//  VCDayCell.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//

import UIKit
#if os(iOS)
open class VCDayCell: UICollectionViewCell {
    public static var reuseIdentifier: String = "VerticalCalendarDayCell"
    public var day: (any VCDay)!
    
    private var label: VCDayCellLabel!
    private var topBorder: VCDayCellTopBorder!
    
    public var labelView: UIView { label as UIView }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.label = VCDayCellLabel(parent: contentView)
        self.topBorder = VCDayCellTopBorder(parent: contentView)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.day = nil
        label.prepare()
        topBorder.prepare()
    }
    
    open func configure(day: any VCDay) {
        self.day = day
        label.configure(with: day)
        topBorder.configure(with: day)
    }
}
#endif


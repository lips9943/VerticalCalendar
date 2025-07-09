//
//  HDSCollectionViewCell.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

import UIKit
internal import Then

class HDSCollectionViewCell: UICollectionViewCell {
    static let identifier = "HDSCollectionViewCell"
    static var bgColor: UIColor = .white
    static var dayColor: UIColor = .label
    static var weekendColor: UIColor = .systemGray
    static var weekDayColor: UIColor = .systemGray2
    
    private var viewModel: HDSViewModel?
    private var model: HSCDayModel?
    
    
    
    var dayLabel: UILabel!
    
    var weekDayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabels()
        uiSetUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        model = nil
        dayLabel.text = nil
        dayLabel.textColor = .clear
        weekDayLabel.text = nil
        weekDayLabel.textColor = .clear
    }
    
    private func setLabels() {
        dayLabel = UILabel().then {
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.textAlignment = .center
            $0.textColor = .label
        }
        weekDayLabel = UILabel().then {
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textAlignment = .center
            $0.textColor = .systemGray2
        }
    }
    
    private func uiSetUp() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.addSubview(dayLabel)
        contentView.addSubview(weekDayLabel)
        setLayout()
    }
    
    private func setLayout() {
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(weekDayLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview()
        }
        weekDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.bottom.equalTo(dayLabel.snp.top)
            make.width.equalToSuperview()
        }
    }
    
    func configure(model: HSCDayModel, viewModel: HDSViewModel) {
        self.viewModel = viewModel
        self.model = model
        dayConfigure(model: model)
    }
    
    private func dayConfigure(model: HSCDayModel) {
        dayLabel.text = "\(model.day)"
        weekDayLabel.text = model.weekDayLabel
        if model.isWeekend {
            dayLabel.textColor = .systemGray
            weekDayLabel.textColor = .systemGray2
        } else {
            dayLabel.textColor = .label
            weekDayLabel.textColor = .systemGray2
        }
    }
}

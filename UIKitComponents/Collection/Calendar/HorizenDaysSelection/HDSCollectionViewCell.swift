//
//  HDSCollectionViewCell.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

import UIKit
internal import Then
internal import SnapKit

class HDSCollectionViewCell: UICollectionViewCell {
    static let identifier = "HDSCollectionViewCell"
    static var bgColor: UIColor = .clear
    static var dayColor: UIColor = .label
    static var weekendColor: UIColor = .systemGray
    static var weekDayColor: UIColor = .systemGray2
    static var cornerRadius: CGFloat = 8
    static var alpha: CGFloat = 1
    static var blur: UIBlurEffect.Style = .systemMaterial
    static var isBlurAvailable: Bool = true
    
    private var viewModel: HDSViewModel?
    private var model: HDSDayModel?
    
    var blurView: CustomBlurView!
    var dayLabel: UILabel!
    var weekDayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
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
    
    private func setViews() {
        blurView = CustomBlurView()
        
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
        contentView.layer.cornerRadius = HDSCollectionViewCell.cornerRadius
        contentView.clipsToBounds = true
        contentView.backgroundColor = HDSCollectionViewCell.bgColor
        contentView.alpha = HDSCollectionViewCell.alpha
        contentView.addSubview(blurView)
        blurView.contentView.addSubview(dayLabel)
        blurView.contentView.addSubview(weekDayLabel)
        blurView.isEnable = HDSCollectionViewCell.isBlurAvailable
        if HDSCollectionViewCell.isBlurAvailable {
            blurView.blurEffect = HDSCollectionViewCell.blur
        }
        setLayout()
    }
    
    private func setLayout() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
    
    func configure(model: HDSDayModel, viewModel: HDSViewModel) {
        self.viewModel = viewModel
        self.model = model
        dayConfigure(model: model)
    }
    
    private func dayConfigure(model: HDSDayModel) {
        dayLabel.text = "\(model.day)"
        weekDayLabel.text = model.weekDayLabel
        weekDayLabel.textColor = HDSCollectionViewCell.weekDayColor
        if model.isWeekend {
            dayLabel.textColor = HDSCollectionViewCell.weekendColor
        } else {
            dayLabel.textColor = HDSCollectionViewCell.dayColor
        }
    }
}

//
//  HDS.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

import UIKit
internal import SnapKit

open class HorizenDaysSelection: UIView {
    public enum Posision { case top, bottom }
    
    private let fixedHeight: CGFloat
    private let currentSize: CGSize
    
    private(set) var collectionView: HDSCollectionView!
    private(set) var viewModel: HDSViewModel!
    private var blurView: CustomBlurView!
    
    // MARK: - User's Getter
    public var view: UICollectionView {
        return collectionView
    }
    
    // MARK: - User
    public var blur: UIBlurEffect.Style = .systemMaterial {
        didSet { blurView.effect = UIBlurEffect(style: blur)}
    }
    public var cellBlur: UIBlurEffect.Style = .systemMaterial {
        didSet { HDSCollectionViewCell.blur = cellBlur }
    }
    public var isBlurAvailable: Bool = false {
        didSet {
            blurView.isEnable = isBlurAvailable
        }
    }
    public var isCellBlurAvailable: Bool = true {
        didSet {
            HDSCollectionViewCell.isBlurAvailable = isCellBlurAvailable
        }
    }
    public var posision: Posision = .bottom {
        didSet {
            let screenBounds = UIScreen.main.bounds
            switch posision {
            case .top:
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: screenBounds.width,
                                   height: fixedHeight)
                self.frame = frame
                break
            case .bottom:
                let frame = CGRect(x: 0,
                                   y: screenBounds.height - fixedHeight,
                                   width: screenBounds.width,
                                   height: fixedHeight)
                self.frame = frame
                break
            }
        }
    }
    public var bgColor: UIColor = .clear {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    public var cellBGColor: UIColor = .clear {
        didSet { HDSCollectionViewCell.bgColor = cellBGColor }
    }
    public var dayFontColor: UIColor = .label {
        didSet { HDSCollectionViewCell.dayColor = dayFontColor }
    }
    public var weekendFontColor: UIColor = .white {
        didSet { HDSCollectionViewCell.weekendColor = weekendFontColor }
    }
    public var weekDayFontColor: UIColor = .white {
        didSet { HDSCollectionViewCell.weekDayColor = weekDayFontColor }
    }
    public var cornerRadius: CGFloat = 8 {
        didSet { HDSCollectionViewCell.cornerRadius = cornerRadius }
    }
    public var cellAlpha: CGFloat = 1 {
        didSet { HDSCollectionViewCell.alpha = cellAlpha }
    }
    public var betweenCellLineSpacing: CGFloat = 4 {
        didSet { collectionView.layout?.minimumLineSpacing = betweenCellLineSpacing }
    }
    public var itemDidSelected: ((Date) -> Void)?
    
    public init() {
        let screenBounds = UIScreen.main.bounds
        currentSize = .init(width: screenBounds.width,
                            height: screenBounds.height)
        fixedHeight = currentSize.height * 0.1
        let frame = CGRect(x: screenBounds.minX,
                           y: screenBounds.height - fixedHeight,
                           width: screenBounds.width,
                           height: fixedHeight)
        
        super.init(frame: frame)
        backgroundColor = bgColor
        setUp()
        blurViewSetUp()
        tableSetUp()
        setScrollToTodayCell()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        viewModel = HDSViewModel()
        blurView = CustomBlurView()
        collectionView = HDSCollectionView(layout: viewModel.layoutManager.setLayout(with: fixedHeight))
    }
    
    private func blurViewSetUp() {
        blurView.isEnable = false
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func tableSetUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
        blurView.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setScrollToTodayCell() {
        guard let indexPath = viewModel.getIndexPathForToday() else { return }
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

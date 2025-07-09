//
//  FloatTableView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 3/26/25.
//
import UIKit
import Combine
internal import RxSwift
internal import RxCocoa
internal import Then
internal import SnapKit
internal import RxGesture

public protocol FloatTableViewDelegate {
    func contentOffsetDidChange(isScrollMovesUpperSide: Bool)
}

/// FloatTableViewController는 기본적인 UITableView에 커스텀 Header와 Footer를 사용하여 TableView를 스크롤할 때 Reactive하게 Header와 Footer를 움직이기 위한 Controller입니다.
open class FloatTableViewController: UIViewController {
    public enum HeadFooterPosition {
        case HeaderHeightFooterHeight
        case HeaderHeightFooterBottom
        case HeaderTopFooterHeight
        case HeaderTopFooterBottom
    }
    let disposeBag = DisposeBag()
    var disposableHeaderFooter: Disposable?
    var headerHeightConstraint: Constraint?
    var headerTopConstraint: Constraint?
    var footerHeightConstraint: Constraint?
    var footerBottomConstraint: Constraint?
    var previousScrollOffset: CGFloat = 0
    var isAnimating: Bool = false
    var cancellables: Set<AnyCancellable> = []
    private lazy var _headerView: UIView = UIView()
    private lazy var _footerView: UIView = UIView()
    
    // MARK: - Public Properties
    public var delegate: FloatTableViewDelegate?
    public let tableView: UITableView!
    public var refreshControl: UIRefreshControl? {
        get { tableView.refreshControl }
        set { tableView.refreshControl = newValue }
    }
    public var headerView: UIView {
        get { _headerView }
        set {
            _headerView.removeFromSuperview()
            _headerView = newValue
            view.addSubview(_headerView)
            _headerView.snp.makeConstraints { make in
                headerTopConstraint = make.top.equalToSuperview().constraint
                make.leading.trailing.equalToSuperview()
                headerHeightConstraint = make.height.equalTo(_headerHeight.value).constraint
            }
        }
    }
    public var footerView: UIView {
        get { _footerView }
        set {
            _footerView.removeFromSuperview()
            _footerView = newValue
            view.addSubview(_footerView)
            _footerView.snp.makeConstraints { make in
                footerBottomConstraint = make.bottom.equalToSuperview().constraint
                make.leading.trailing.equalToSuperview()
                footerHeightConstraint = make.height.equalTo(_footerHeight.value).constraint
            }
        }
    }
    
    /// Header와 Footer의 고정 포지션을 정합니다. 기본적으로 두가지의 포지션이 있습니다.
    /// 스크롤 할 때 지정된 포지션의 값을 변경해 Header와 Footer에 변화를 줍니다.
    /// - Height: 길이 늘리고 줄임으로써 크기에 변화를 줍니다. 주로 View 안 값들이 Label일 때 사용하기 좋습니다.
    /// - Top, Bottom: Header는 상단(Top), Footer는 하단(Bottom)에 지정 포지션으로 설정하여 스크롤 할 때
    public var headFootPosition: HeadFooterPosition = .HeaderTopFooterBottom { didSet {
        switch  headFootPosition {
        case .HeaderHeightFooterHeight:
            disposableHeaderFooter?.dispose()
            disposableHeaderFooter = contentOffsetHeaderHeightFooterHeight()
        case .HeaderHeightFooterBottom:
            disposableHeaderFooter?.dispose()
            disposableHeaderFooter = contentOffsetHeaderHeightFooterBottom()
        case .HeaderTopFooterHeight:
            disposableHeaderFooter?.dispose()
            disposableHeaderFooter = contentOffsetHeaderTopFooterHeight()
        case .HeaderTopFooterBottom:
            disposableHeaderFooter?.dispose()
            disposableHeaderFooter = contentOffsetHeaderTopFooterBottom()
        }
    }}
    
    /// Header의 최소 Height
    public var minHeaderHeight: CGFloat = 30
    /// Header의 최대 길이를 조정합니다.
    public var headerHeight: CGFloat = 70 { didSet { _headerHeight.send(headerHeight) } }
    
    /// Footer의 최소 길이를 조정합니다.
    public var minFooterHeight: CGFloat = 20
    /// Footer의 최대 길이를 조정합니다.
    public var footerHeight: CGFloat = 30 { didSet { _footerHeight.send(footerHeight) } }
    
    /// Header의 Bottom과 TableView의 Top의 사이 길이를 조정합니다.
    public var tableTopInset: CGFloat = 0 { didSet { betweenTableAndHeader.send(tableTopInset) } }
    
    // MARK: - Header & Footer Layout Subject Properties
    private(set) var _headerHeight: CurrentValueSubject<CGFloat, Never> = .init(70)
    private(set) var _footerHeight: CurrentValueSubject<CGFloat, Never> = .init(70)
    private(set) var betweenTableAndHeader: CurrentValueSubject<CGFloat, Never> = .init(0)
    
    // MARK: - Size Properties
    private(set) var topSafeAreaInset: CurrentValueSubject<UIEdgeInsets, Never> = .init(.zero)
    
    // MARK: - Change Header & Footer Properties
    private(set) var velocityAndTranslation: PassthroughSubject<(CGFloat, CGFloat), Never> = .init()
    private(set) var isScrollMovesUpperSide: CurrentValueSubject<Bool?, Never> = .init(nil)
    
    // MARK: - From Super Class
    public init(tableView: UITableView = UITableView(frame: .zero, style: .grouped)) {
        self.tableView = tableView
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        disposableHeaderFooter?.dispose()
        disposableHeaderFooter = nil
        
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let inset = tableView.safeAreaInsets
        topSafeAreaInset.send(inset)
    }
}





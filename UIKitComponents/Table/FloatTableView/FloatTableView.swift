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

public class FloatTableViewController: UIViewController {
    public enum HeadFooterPosition {
        case HeaderHeightFooterHeight
        case HeaderHeightFooterBottom
        case HeaderTopFooterHeight
        case HeaderTopFooterBottom
    }
    private let disposeBag = DisposeBag()
    private var disposableHeaderFooter: Disposable?
    private var headerHeightConstraint: Constraint?
    private var headerTopConstraint: Constraint?
    private var footerHeightConstraint: Constraint?
    private var footerBottomConstraint: Constraint?
    private var previousScrollOffset: CGFloat = 0
    private var isAnimating: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private lazy var _headerView: UIView = UIView()
    private lazy var _footerView: UIView = UIView()
    
    // MARK: - Public Properties
    public var delegate: FloatTableViewDelegate?
    public let tableView: UITableView!
    public var refreshControl: UIRefreshControl? {
        get { tableView.refreshControl }
        set { tableView.refreshControl = newValue }
    }
    
    
    /// Header를 설정합니다.
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
    /// Footer를 설정합니다..
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
    
    /// Header의 움직임의 기준을 Top으로 할 지 Height로 할 지 정합니다. 기본값은 Height: false
    public var headFootPosition: HeadFooterPosition = .HeaderTopFooterBottom { didSet {
        switch  headFootPosition {
        case .HeaderHeightFooterHeight:
            disposableHeaderFooter?.dispose()
            disposableHeaderFooter = contentOffsetHeaderTopFooterHeight()
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
    
    // MARK: - Header & Footer Layout Subject Properties
    private var _headerHeight: CurrentValueSubject<CGFloat, Never> = .init(70)
    private var _footerHeight: CurrentValueSubject<CGFloat, Never> = .init(70)
    
    // MARK: - Size Properties
    private var topSafeAreaInset: CurrentValueSubject<CGFloat, Never> = .init(0)
    
    // MARK: - Change Header & Footer Properties
    private var velocityAndTranslation: PassthroughSubject<(CGFloat, CGFloat), Never> = .init()
    private var isScrollMovesUpperSide: CurrentValueSubject<Bool, Never> = .init(false)
    
    // MARK: - From Super Class
    init(tableView: UITableView = UITableView(frame: .zero, style: .grouped)) {
        self.tableView = tableView
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        disposableHeaderFooter?.dispose()
        disposableHeaderFooter = nil
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topSafeAreaInset.send(tableView.safeAreaInsets.top)
    }
}

// MARK: - Header & Footer
extension FloatTableViewController {
    private func headerConfigure() {
        _headerView.backgroundColor = .systemGray2.withAlphaComponent(0.96)
        _headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        _headerView.layer.masksToBounds = true
        _headerView.layer.cornerRadius = 10
        _headerView.snp.makeConstraints { make in
            headerTopConstraint = make.top.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
            headerHeightConstraint = make.height.equalTo(_headerHeight.value).constraint
        }
    }
    private func footerConfigure() {
        _footerView.backgroundColor = .systemBrown.withAlphaComponent(0.9)
        _footerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        _footerView.layer.masksToBounds = true
        _footerView.layer.cornerRadius = 10
        _footerView.snp.makeConstraints { make in
            footerBottomConstraint = make.bottom.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
            footerHeightConstraint = make.height.equalTo(_footerHeight.value).constraint
        }
    }
}

// MARK: - Configurations
extension FloatTableViewController {
    private func configuration() {
        view.addSubview(tableView)
        view.addSubview(_headerView)
        view.addSubview(_footerView)
        tableViewConfigure()
        headerConfigure()
        footerConfigure()
        bindingUI()
    }
    private func tableViewConfigure() {
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Binding
extension FloatTableViewController {
    private func bindingUI() {
        // Header & Footer
        headerLayoutAlwaysBindingUI()
        footerLayoutAlwaysBindingUI()
        headerHeightBindingToTableView()
        
        //
        endGestureWillResetConstraints()
        isUpperSideBindingToDelegate()
        headFootPosition = .HeaderTopFooterBottom
    }
    // MARK: - Layout Binding
    private func headerHeightBindingToTableView() {
        Publishers.CombineLatest(_headerHeight, topSafeAreaInset)
            .filter { $0.0 != CGFloat(0) }
            .map { [$0, $1] }
            .removeDuplicates()
            .sink {
                self.tableView.contentInset.top = $0[0] - $0[1]
                self.tableView.setContentOffset(CGPoint(x: 0, y: -$0[0]), animated: false)
            }.store(in: &cancellables)
    }
    private func headerLayoutAlwaysBindingUI() {
        _headerHeight.sink { [weak self] value in
            guard let self else { return }
            self._headerView.snp.updateConstraints { make in
                make.height.equalTo(value)
            }
            self.loadViewIfNeeded()
        }
        .store(in: &cancellables)
    }
    private func footerLayoutAlwaysBindingUI() {
        _footerHeight.sink { [weak self] value in
            guard let self else { return }
            self._footerView.snp.updateConstraints { make in
                make.height.equalTo(value)
            }
            self.loadViewIfNeeded()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Pan Gesture For Constraints
    private func endGestureWillResetConstraints() {
        tableView.rx
            .panGesture()
            .when(.ended)
            .filter { _ in self.isAnimating == false }
            .observe(on: MainScheduler.instance)
            .bind { gesture in
                let maxHeaderHeight: CGFloat = self._headerHeight.value
                let minHeaderHeight: CGFloat = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                if self.isScrollMovesUpperSide.value {
                    switch self.headFootPosition {
                    case .HeaderTopFooterBottom:
                        self.headerTopConstraint?.update(inset: 0)
                        self.footerBottomConstraint?.update(offset: 0)
                    case .HeaderHeightFooterBottom:
                        self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                        self.footerBottomConstraint?.update(offset: 0)
                    case .HeaderTopFooterHeight:
                        self.headerTopConstraint?.update(inset: 0)
                        self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    case .HeaderHeightFooterHeight:
                        self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                        self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    }
                } else {
                    switch self.headFootPosition {
                    case .HeaderTopFooterBottom:
                        self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight))
                        self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    case .HeaderHeightFooterBottom:
                        self.headerHeightConstraint?.update(offset: minHeaderHeight)
                        self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    case .HeaderTopFooterHeight:
                        self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight))
                        self.footerHeightConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    case .HeaderHeightFooterHeight:
                        self.headerHeightConstraint?.update(offset: minHeaderHeight)
                        self.footerHeightConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    }
                    
                }
                UIView.animate(withDuration: 0.1, delay: 0, options: []) {
                    self.view.layoutIfNeeded()
                }
                
                self.previousScrollOffset = self.tableView.contentOffset.y
                return
            }.disposed(by: disposeBag)
            
    }
    
    // MARK: - Content Offset For Constraints
    private func isUpperSideBindingToDelegate() {
        isScrollMovesUpperSide
            .removeDuplicates()
            .sink { [weak self] value in
                self?.delegate?.contentOffsetDidChange(isScrollMovesUpperSide: value)
            }.store(in: &cancellables)
    }
    private func contentOffsetHeaderHeightFooterHeight() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .filter { $0 > CGFloat(-(self._headerHeight.value)) && self.tableView.contentSize.height - self.tableView.frame.height > $0 }
            .bind {
                let maxHeaderHeight: CGFloat = self._headerHeight.value
                let minHeaderHeight: CGFloat = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight

                let offsetY = $0
                let delta = offsetY - self.previousScrollOffset
                
                var newHeaderHeight = self.headerHeightConstraint?.layoutConstraints.first?.constant ?? maxHeaderHeight
                var newFooterHeight = self.footerHeightConstraint?.layoutConstraints.first?.constant ?? maxFooterHeight
                
                newHeaderHeight -= delta
                newFooterHeight -= delta
                
                newHeaderHeight = max(minHeaderHeight, min(maxHeaderHeight, newHeaderHeight))
                newFooterHeight = max(minFooterHeight, min(maxFooterHeight, newFooterHeight))
                
                self.footerHeightConstraint?.update(offset: newFooterHeight)
                self.headerHeightConstraint?.update(offset: newHeaderHeight)
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    private func contentOffsetHeaderHeightFooterBottom() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .filter { $0 > CGFloat(-(self._headerHeight.value)) && self.tableView.contentSize.height - self.tableView.frame.height > $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] offsetY in
                guard let self = self else { return }
                isAnimating = false
                let maxHeaderHeight: CGFloat = self._headerHeight.value
                let minHeaderHeight: CGFloat = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                
                let delta = offsetY - self.previousScrollOffset
                
                var newHeaderHeight = self.headerHeightConstraint?.layoutConstraints.first?.constant ?? maxHeaderHeight
                var newFooterBottom = self.footerBottomConstraint?.layoutConstraints.first?.constant ?? self.view.bounds.height
                
                newHeaderHeight -= delta
                newFooterBottom += delta
                
                newHeaderHeight = max(minHeaderHeight, min(maxHeaderHeight, newHeaderHeight))
                newFooterBottom = max(minFooterHeight, min(maxFooterHeight - minFooterHeight, newFooterBottom))
                
                if maxHeaderHeight - ((maxHeaderHeight - minHeaderHeight * 2) * 0.13) >= newHeaderHeight, delta > 0 {
                    self.headerHeightConstraint?.update(offset: minHeaderHeight)
                    self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    isAnimating = true
                } else if delta < 0, minHeaderHeight + ((maxHeaderHeight - minHeaderHeight * 2) * 0.13) <= newHeaderHeight {
                    self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                    self.footerBottomConstraint?.update(offset: 0)
                    isAnimating = true
                }
                
                
                if isAnimating {
                    UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    self.isScrollMovesUpperSide.send(delta < 0)
                    self.previousScrollOffset = offsetY
                    return
                }

                self.headerHeightConstraint?.update(offset: newHeaderHeight)
                self.footerBottomConstraint?.update(offset: newFooterBottom)
                
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    private func contentOffsetHeaderTopFooterHeight() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .filter { $0 > CGFloat(-(self._headerHeight.value)) && self.tableView.contentSize.height - self.tableView.frame.height > $0 }
            .observe(on: MainScheduler.instance)
            .bind {
                let maxHeaderHeight = self._headerHeight.value
                let minHeaderHeight = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                
                let offsetY = $0
                let delta = offsetY - self.previousScrollOffset
                var newTopHeader = self.headerTopConstraint?.layoutConstraints.first?.constant ?? 0
                var newFooterHeight = self.footerHeightConstraint?.layoutConstraints.first?.constant ?? maxFooterHeight
                
                newTopHeader -= delta
                newFooterHeight -= delta
                
                newTopHeader = max(-(maxHeaderHeight - minHeaderHeight), min(0, newTopHeader))
                newFooterHeight = max(minFooterHeight, min(maxFooterHeight, newFooterHeight))
                
                self.headerTopConstraint?.update(inset: newTopHeader)
                self.footerHeightConstraint?.update(offset: newFooterHeight)
                
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    private func contentOffsetHeaderTopFooterBottom() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .filter { $0 > CGFloat(-(self._headerHeight.value)) && self.tableView.contentSize.height - self.tableView.frame.height > $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] offsetY in
                guard let self else { return }
                isAnimating = false
                let maxHeaderHeight = self._headerHeight.value
                let minHeaderHeight = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                
                let delta = offsetY - self.previousScrollOffset
                var newTopHeader = self.headerTopConstraint?.layoutConstraints.first?.constant ?? 0
                var newFooterBottom = self.footerBottomConstraint?.layoutConstraints.first?.constant ?? self.view.bounds.height
                
                newTopHeader -= delta
                newFooterBottom += delta
                
                newTopHeader = max(-(maxHeaderHeight - minHeaderHeight), min(0, newTopHeader))
                newFooterBottom = max(minFooterHeight, min(maxFooterHeight - minFooterHeight, newFooterBottom))
                print(maxHeaderHeight, newTopHeader, minHeaderHeight)
                
                if -((maxHeaderHeight - minHeaderHeight) * 0.13) >= newTopHeader, delta > 0 {
                    self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight + self._headerTopInset.value) )
                    self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    isAnimating = true
                } else if delta < 0, -(minHeaderHeight + ((maxHeaderHeight - minHeaderHeight) * 0.87)) <= newTopHeader {
                    self.headerTopConstraint?.update(inset: 0 + self._headerTopInset.value)
                    self.footerBottomConstraint?.update(offset: 0)
                    isAnimating = true
                }
                
                if isAnimating {
                    UIView.animate(withDuration: 0.5, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    
                    self.isScrollMovesUpperSide.send(delta < 0)
                    self.previousScrollOffset = offsetY
                    return
                }
                
                
                self.headerTopConstraint?.update(inset: newTopHeader)
                self.footerBottomConstraint?.update(offset: newFooterBottom)
                
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    
}


#if DEBUG

#Preview(traits: .defaultLayout, body: {
    FloatTableViewControllerTest()
})
class FloatTableViewControllerTest: FloatTableViewController, FloatTableViewDelegate {
    func contentOffsetDidChange(isScrollMovesUpperSide: Bool) {
        print(isScrollMovesUpperSide)
    }
        
    
    
    let bag = DisposeBag()
    let header = UIView().then {
        $0.backgroundColor = .red.withAlphaComponent(0.3)
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(100, forKey: kCIInputRadiusKey) // 블러 강도 설정
        let label = UILabel()
        label.text = "sldfkjsldjfkk"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.layer.backgroundFilters = [blurFilter] // UIView에 필터 적용
    }
    
    var items: BehaviorRelay<[String]> = .init(value: Array(1...100).map(\.description))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .systemBlue
        dataConfigure()
        headerView = header
        headerHeight = 150
        minHeaderHeight = 50
        footerHeight = 150
        minFooterHeight = 50
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
extension FloatTableViewControllerTest {
    func dataConfigure() {
        guard let refreshControl else { return }
        tableView.register(FloatTableViewCell.self, forCellReuseIdentifier: "cell")
        items
            .bind(to:  tableView.rx.items(cellIdentifier: "cell", cellType: FloatTableViewCell.self)) { indexPath, element, cell in
                cell.selectionStyle = .none
                cell.title.text = element
            }
            .disposed(by: bag)
        
        // Pull-to-Refresh 이벤트 바인딩
        refreshControl.rx.controlEvent(.valueChanged)
            .flatMapLatest { [weak self] _ -> Observable<[String]> in
                guard let self = self else { return .empty() }
                return self.addDatas().observe(on: MainScheduler.instance)
            }
            .subscribe(onNext: { [weak self] newItems in
                self?.items.accept(newItems)
                self?.refreshControl?.endRefreshing()
            })
            .disposed(by: bag)
    }
    
    
    func addDatas() -> Observable<[String]> {
        let data = Observable.just(Array(1...100).map(\.description)).delay(.seconds(3), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
        return data
    }
}


class FloatTableViewCell: UITableViewCell {
    let title: UILabel = .init().then { l in
        l.font = .systemFont(ofSize: 17)
        l.textColor = .black
        l.textAlignment = .center
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray3
        addSubview(title)
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

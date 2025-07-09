//
//  SegmentTabBarController.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/19/25.
//

import UIKit
internal import RxSwift
internal import RxCocoa
internal import SnapKit

internal import Then
import Combine


open class SegmentTabBarController: UIViewController {
    // MARK: - Public Properties
    /// 탭 바의 배경색을 지정합니다.
    public var controlBackgroundColor: UIColor? {
        didSet { segmentControl.backgroundColor = controlBackgroundColor }
    }
    public var controlTintColor: UIColor? {
        didSet { segmentControl.tintColor = controlTintColor }
    }
    public var controlSelectedColor: UIColor? {
        didSet { segmentControl.selectedSegmentTintColor = controlSelectedColor }
    }
    
    // MARK: - Navigation Bar
    public var navigationRightItem: UIBarButtonItem? {
        didSet { navigationItem.rightBarButtonItem = navigationRightItem }
    }
    public var navigationLeftItem: UIBarButtonItem? {
        didSet { navigationItem.leftBarButtonItem = navigationLeftItem }
    }
    
    // MARK: - 
    public var selectedIndex: Int {
        segmentControl.selectedSegmentIndex
    }
    public var startedIndex: Int = 0 {
        didSet {
            segmentControl.selectedSegmentIndex = startedIndex
            selectViewController(at: startedIndex)
        }
    }
    
    public var selectedIndexSubject: CurrentValueSubject<Int, Never> = .init(0)
    
    // MARK: - Private Properties
    private var segmentControl: UISegmentedControl
    private let containerView: UIView!
    private var viewControllers: [UIViewController] = []
    private var currentViewController: UIViewController?
    
    // MARK: - Public
    public func insertViewController(_ viewController: UIViewController, title: String, at index: Int) {
        guard (0...4).contains(viewControllers.count) else { return }
        viewControllers.insert(viewController, at: index)
        segmentControl.insertSegment(withTitle: title, at: index, animated: false)
    }
    
    public func insertViewController(_ viewController: UIViewController, image: UIImage?, at index: Int) {
        guard (0...4).contains(viewControllers.count) else { return }
        viewControllers.insert(viewController, at: index)
        segmentControl.insertSegment(with: image, at: index, animated: false)
    }

    // MARK: - Initializer
    public init(viewControllers: [UIViewController], title: String) {
        // 초기화 시 뷰 컨트롤러 배열 전달
        
        self.viewControllers = viewControllers
        self.segmentControl = UISegmentedControl(items: viewControllers.map { $0.title ?? "View" })
        self.containerView = UIView()
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        guard (2...4).contains(viewControllers.count) else {
            fatalError("SegmentTabBarController requires 2 to 4 view controllers.")
        }
    }
    
    public init() {
        self.segmentControl = UISegmentedControl()
        self.containerView = UIView()
        super.init(nibName: nil, bundle: nil)
        
        guard (0...4).contains(viewControllers.count) else {
            fatalError("ViewController must have less than or equal to 4 view controllers.")
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setUpViewController(at: 0) // 첫 번째 뷰 컨트롤러를 초기 선택
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // SegmentedControl 설정
        segmentControl.selectedSegmentIndex = 0
        view.addSubview(segmentControl)
        
        // ContainerView 설정
        view.addSubview(containerView)
        
        // Layout Constraints
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    

    // MARK: - Actions
    private func setupActions() {
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let currentIndex = sender.selectedSegmentIndex
        selectedIndexSubject.send(currentIndex)
        selectViewController(at: currentIndex)
    }
    
    private func setUpViewController(at index: Int) {
        let selectedViewController = viewControllers[index]
        // 기존 ViewController 제거
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        // 새로운 ViewController 추가
        addChild(selectedViewController)
        containerView.addSubview(selectedViewController.view)
        selectedViewController.view.frame = containerView.bounds
        selectedViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedViewController.didMove(toParent: self)
        
        view.backgroundColor = selectedViewController.view.backgroundColor
        // 현재 ViewController 업데이트
        currentViewController = selectedViewController
    }

    // MARK: - Helper Methods
    public func selectViewController(at index: Int) {
        let selectedViewController = viewControllers[index]
        
        // 새로운 ViewController 추가
        addChild(selectedViewController)
        containerView.insertSubview(selectedViewController.view, at: 0)
        
        selectedViewController.view.frame = containerView.bounds
        selectedViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedViewController.didMove(toParent: self)
        
        view.backgroundColor = selectedViewController.view.backgroundColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() /*+ 0.138*/) { [weak self] in
            guard let self else { return }
            
            // 기존 ViewController 제거
            currentViewController?.willMove(toParent: nil)
            currentViewController?.view.removeFromSuperview()
            currentViewController?.removeFromParent()
            
            // 현재 ViewController 업데이트
            currentViewController = selectedViewController
        }
    }
}

#if DEBUG

#Preview(traits: .defaultLayout, body: {
    let seg = SegmentTabBarController()
    seg.insertViewController(FirstVC(), title: "First", at: 0)
    seg.insertViewController(SecondVC(), title: "Second", at: 1)
    return seg
})

class FirstVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

class SecondVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
#endif

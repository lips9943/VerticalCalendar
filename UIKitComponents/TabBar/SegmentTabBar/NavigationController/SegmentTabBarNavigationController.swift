//
//  SegmentTabBarTest.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/9/25.
//
import UIKit
internal import SnapKit
internal import RxFlow
@available(iOS 14.0, *)
open class SegmentTabBarNavigationController: UINavigationController {
    var tabs: [SegmentTab]
    var customStep: (any CustomStringConvertible & Step)?
    
    private let rootVC: SegmentViewController
    
    public enum SegmentLocation {
        case bottom
        case top
    }
    public var tabBarDelegate: SegmentTabBarDelegate? {
        didSet { rootVC.delegate = tabBarDelegate }
    }
    public var changeColorEachTabBySelect: Bool = false {
        didSet {
            rootVC.changeColorEachTabBySelect = changeColorEachTabBySelect
        }
    }
    /// - Note: 각 Segment의 TintColor입니다. 파라미터(changeColorEachTabBySelect)가 False일 때 적용됩니다.
    public var selectedSegmentTintColor: UIColor = .white {
        didSet { rootVC.selectedSegmentTintColor = selectedSegmentTintColor }
    }
    public var controlBackgroundColor: UIColor? {
        didSet { rootVC.controlBackgroundColor = controlBackgroundColor }
    }
    public var setLocation: SegmentLocation? {
        didSet {
            guard let setLocation else { return }
            rootVC.changeLocationOfSegment(to: setLocation)
        }
    }
    
    public var currentIndex: Int { rootVC.currentIndex }
    
    // MARK: - Navigation Bar 관련 Properties
    public var navigationBarTitle: String? {
        didSet { rootVC.title = navigationBarTitle }
    }
    public var rightItem: UIBarButtonItem? {
        didSet { rootVC.navigationItem.setRightBarButton(rightItem, animated: true) }
    }
    public var leftItem: UIBarButtonItem? {
        didSet { rootVC.navigationItem.setLeftBarButton(leftItem, animated:     true) }
    }
    public var rightItems: [UIBarButtonItem]? {
        didSet { rootVC.navigationItem.setRightBarButtonItems(rightItems, animated: true) }
    }
    public var leftItems: [UIBarButtonItem]? {
        didSet { rootVC.navigationItem.setLeftBarButtonItems(leftItems, animated: true) }
    }
    
    public init(tabs: [SegmentTab], startIndex: Int = 0) {
        assert(!tabs.isEmpty, "tabs must not be empty.")
        assert(startIndex >= 0 && startIndex < tabs.count, "startIndex must be in range of tabs.")
        assert(tabs.count <= 4, "SegmentTabBar can not have more than 4 tabs.")
        self.tabs = tabs
        self.rootVC = SegmentViewController(tabs: tabs, startIndex: startIndex)
        super.init(rootViewController: rootVC)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configurations()
    }
    
    public func moveTab(to index: Int) {
        self.rootVC.goToSegment(at: index)
    }
    
    private func configurations() {
        rootVC.navigationItem.largeTitleDisplayMode = .always
        
    }
    
    private func removeViewController(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.removeFromParent()
        vc.view.removeFromSuperview()
    }
}

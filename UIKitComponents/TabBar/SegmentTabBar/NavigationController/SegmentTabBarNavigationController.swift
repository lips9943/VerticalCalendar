//
//  SegmentTabBarTest.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/9/25.
//
import UIKit
internal import SnapKit

@available(iOS 14.0, *)
public class SegmentTabBarNavigationController: UINavigationController {
    var tabs: [SegmentTab]
    
    private let rootVC: SegmentViewController
    private var currentVC: UIViewController?
    public var root: SegmentViewController { rootVC }
    public var changeColorEachTabBySelect: Bool = false {
        didSet {
            rootVC.changeColorEachTabBySelect = changeColorEachTabBySelect
        }
    }
    /// - Note: 각 Segment의 TintColor입니다. 파라미터(changeColorEachTabBySelect)가 False일 때 적용됩니다.
    public var selectedSegmentTintColor: UIColor = .white {
        didSet { rootVC.selectedSegmentTintColor = selectedSegmentTintColor }
    }
    
    public init(tabs: [SegmentTab], startIndex: Int = 0) {
        assert(!tabs.isEmpty, "tabs must not be empty.")
        assert(startIndex >= 0 && startIndex < tabs.count, "startIndex must be in range of tabs.")
        assert(tabs.count <= 4, "SegmentTabBar can not have more than 4 tabs.")
        self.tabs = tabs
        self.currentVC = tabs[startIndex].viewController
        self.rootVC = SegmentViewController(tabs: tabs, startIndex: startIndex)
        super.init(rootViewController: rootVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configurations()
    }
    
    private func configurations() {
        
    }
    
    private func removeViewController(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.removeFromParent()
        vc.view.removeFromSuperview()
    }
}


#if DEBUG
func segmentTabBarNavigationController () -> SegmentTabBarNavigationController {
    let view = SegmentTabBarNavigationController(tabs: [SegmentTab(image: UIImage(systemName: "gear.circle")!, color: UIColor.red) { tab in
        tab.selectedImage = UIImage(systemName: "gear.circle.fill")
        tab.title = "ddd"
        let vc = UIViewController()
        vc.view.backgroundColor = tab.color?.withAlphaComponent(0.2)
        return vc
    }, SegmentTab(title: "second", color: UIColor.cyan) { tab in
        let vc = UIViewController()
        vc.view.backgroundColor = tab.color?.withAlphaComponent(0.2)
        return vc
    }], startIndex: 1)
    
    view.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .plain, target: nil, action: nil)
    view.root.changeColorEachTabBySelect.toggle()
    view.root.changeLocationOfSegment(to: .bottom)
    return view
}

#Preview(traits: .defaultLayout, body: {
    segmentTabBarNavigationController()
    
})

#endif

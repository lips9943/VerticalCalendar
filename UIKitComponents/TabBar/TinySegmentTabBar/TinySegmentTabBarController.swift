//
//  TinySegmentTabBarController.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/11/25.
//

import UIKit
internal import SnapKit

@available(iOS 14.0, *)
open class TinySegmentTabBarController: UIViewController {
    private let tabs: [TinySegmentTab]
    private let _view: UIView = UIView()
    private var blurEffect: CustomBlurView
    private var startIndex: Int
    private var prevIndex: Int?
    private var isSwichingVC: Bool = false
    private var currentViewController: UIViewController! {
        didSet {
            if let oldValue {
                oldValue.removeFromParent()
                oldValue.willMove(toParent: nil)
                oldValue.view.removeFromSuperview()
                oldValue.view.snp.removeConstraints()
            }
            
            self.addChild(currentViewController)
            self.view.insertSubview(currentViewController.view, at: 0)
            self.willMove(toParent: self)
            currentViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    public let control: UISegmentedControl
    public var changeColorEachTabBySelect: Bool = false {
        didSet {
            if changeColorEachTabBySelect {
                DispatchQueue.main.async {
                    self.control.selectedSegmentTintColor =
                        self.tabs[self.startIndex].color
                }
            }
        }
    }
    public var delegate: SegmentTabBarDelegate?
    
    public init(tabs: [TinySegmentTab], startIndex: Int = 0) {
        assert(tabs.count > 0 && tabs.count <= 5, "The number of tabs must be between 1 and 5")
        assert(startIndex < tabs.count, "startIndex must have lower value than tabs's count")
        self.control = UISegmentedControl()
        self.blurEffect = CustomBlurView()
        self.tabs = tabs
        self.startIndex = startIndex
        self.prevIndex = startIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        configuration()
    }
    
    private func configuration() {
        actionConfigure()
        controlViewConfigure()
        blurViewConfigure()
        controlConfigure()
    }
    
    private func controlViewConfigure() {
        _view.backgroundColor = .clear
        self.view.addSubview(_view)
        _view.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(UIScreen.main.bounds.width * self.calculateViewPersent(by: tabs.count))
            make.height.equalTo(UIScreen.main.bounds.height * 0.065)
        }
    }
    
    private func blurViewConfigure() {
        blurEffect.blurEffect = .systemUltraThinMaterial
        blurEffect.backgroundColor = .clear
        blurEffect.layer.cornerRadius = 8
        blurEffect.layer.masksToBounds = true
        _view.addSubview(blurEffect)
        blurEffect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func controlConfigure() {
        control.backgroundColor = .clear
        control.tintColor = .clear
        control.selectedSegmentIndex = startIndex
        self.currentViewController = tabs[startIndex].viewController
        
        if let selectedImage = tabs[startIndex].selectedImage {
            control.setImage(selectedImage, forSegmentAt: startIndex)
        }
        
        _view.addSubview(control)
        control.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func actionConfigure() {
        tabs.enumerated().forEach { (index, tab) in
            let action = UIAction(image: tab.image, selectedImage: tab.selectedImage) { [weak self] action in
                guard let self, !isSwichingVC else { return }
                self.isSwichingVC = true
                self.imageChangeBySelection()

                if self.changeColorEachTabBySelect {
                    self.control.selectedSegmentTintColor = tab.color
                }

                if let selectedImage = tab.selectedImage,
                    self.control.selectedSegmentIndex == index
                {
                    self.control.setImage(selectedImage, forSegmentAt: index)
                }
                
                
                self.prevIndex = index
                self.currentViewController = self.tabs[index].viewController
                self.delegate?.segmentTabBar(didSelectedSegmentAt: index)
                
                self.isSwichingVC = false
            }
            
            control.insertSegment(action: action, at: index, animated: true)
        }
    }
    
    private func calculateViewPersent(by tabCount: Int) -> CGFloat {
        switch tabCount {
        case 1:
            return 0.17
        case 2:
            return 0.33
        case 3:
            return 0.51
        case 4:
            return 0.65
        case 5:
            return 0.84
        default:
            return 0
        }
    }
}

// MARK: - Image Change by Select Protocol
extension TinySegmentTabBarController: TabBarChangingImageBySelect {
    func imageChangeBySelection() {
        guard let prevIndex = self.prevIndex else { return }
        DispatchQueue.main.async {
            self.control.setImage(self.tabs[prevIndex].image, forSegmentAt: prevIndex)
        }
    }
}

#if DEBUG
#Preview(traits: .defaultLayout, body: {
    create()
})

private func create() -> TinySegmentTabBarController {
    let first = TinySegmentTab(image: UIImage(systemName: "door.french.open")!, selectedImage: UIImage(systemName: "door.french.closed"), color: .brown) { tab in
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        return vc
    }
    
    let second = TinySegmentTab(image: UIImage(systemName: "exclamationmark.circle")!, color: .cyan) { tab in
        let vc = UIViewController()
        vc.view.backgroundColor = .systemRed
        return vc
    }
    let vc = TinySegmentTabBarController(tabs: [first, second, second, second, second], startIndex: 0)
    vc.changeColorEachTabBySelect = true
    return vc
}
#endif

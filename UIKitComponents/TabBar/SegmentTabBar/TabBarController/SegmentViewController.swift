
//
//  SegmentViewController.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/9/25.
//
import UIKit
internal import SnapKit

@available(iOS 14.0, *)
class SegmentViewController: UIViewController {
    private let control: UISegmentedControl
    private let tabs: [SegmentTab]
    private let startIndex: Int
    private var prevIndex: Int?
    private var currentLocation: SegmentTabBarNavigationController.SegmentLocation = .top
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
    
    // MARK: - Bool Value By Active During Functions
    private var isSwichingVC: Bool = false
    private var isChangingLocation: Bool = false
    
    var currentIndex: Int { control.selectedSegmentIndex }
    
    var delegate: SegmentTabBarDelegate?
    var changeColorEachTabBySelect: Bool = false {
        didSet {
            if changeColorEachTabBySelect {
                DispatchQueue.main.async {
                    self.control.selectedSegmentTintColor =
                        self.tabs[self.startIndex].color
                }
            }
        }
    }
    var selectedSegmentTintColor: UIColor = .white {
        didSet {
            if !changeColorEachTabBySelect {
                control.selectedSegmentTintColor = selectedSegmentTintColor
            }

        }
    }
    var controlBackgroundColor: UIColor? {
        didSet {
            control.backgroundColor = controlBackgroundColor
        }
    }
    
    init(tabs: [SegmentTab], startIndex: Int) {
        self.tabs = tabs
        self.startIndex = startIndex
        self.prevIndex = startIndex
        self.control = UISegmentedControl()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureControl()
        view.backgroundColor = .clear
    }

    func changeLocationOfSegment(to location: SegmentTabBarNavigationController.SegmentLocation) {
        guard currentLocation != location, !isChangingLocation else { return }
        currentLocation = location
        isChangingLocation = true
        DispatchQueue.main.async {
            switch location {
            case .top:
                self.control.snp.makeConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
                    make.leading.trailing.equalToSuperview().inset(22)
                    make.height.equalTo(UIScreen.main.bounds.height / 23.5)
                }
                self.isChangingLocation = false
                break
            case .bottom:
                self.control.snp.remakeConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
                    make.leading.trailing.equalToSuperview().inset(22)
                    make.height.equalTo(UIScreen.main.bounds.height / 23.5)
                }
                self.isChangingLocation = false
                break
            }
        }
    }
}

// MARK: - UISegmentControl Configure
extension SegmentViewController: TabBarChangingImageBySelect {
    private func configureControl() {
        configureViewAndLayout()
        configureTabs()
        configureControlProperties()
        configureCurrentViewController()
    }

    private func configureViewAndLayout() {
        self.view.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(UIScreen.main.bounds.height / 23.5)
        }
    }

    private func configureControlProperties() {
        control.selectedSegmentIndex = startIndex
        control.selectedSegmentTintColor = selectedSegmentTintColor
        
        control.layer.shadowColor = UIColor.black.cgColor
        control.layer.shadowOffset = CGSize(width: 0, height: 2)
        control.layer.shadowOpacity = 0.2
        control.layer.shadowRadius = 4
        if let selectedImage = tabs[startIndex].selectedImage {
            control.setImage(selectedImage, forSegmentAt: startIndex)
            prevIndex = startIndex
        }
    }

    private func configureTabs() {
        guard !tabs.isEmpty else { return }

        for (index, tab) in self.tabs.enumerated() {
            let action = UIAction(
                title: tab.title ?? "",
                image: tab.image,
                selectedImage: tab.selectedImage,
                identifier: tab.identifier,
                attributes: tab.attributes,
                state: tab.state
            ) { [weak self] action in
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

    func imageChangeBySelection() {
        guard let prevIndex = self.prevIndex else { return }
        if let image = self.tabs[prevIndex].image {
            DispatchQueue.main.async {
                self.control.setImage(image, forSegmentAt: prevIndex)
            }
        }
    }

    private func configureCurrentViewController() {
        self.currentViewController = tabs[startIndex].viewController
    }
    
    func goToSegment(at index: Int) {
        self.isSwichingVC = true
        let tab = tabs[index]
        
        DispatchQueue.main.async {
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
            self.control.selectedSegmentIndex = index
            self.isSwichingVC = false
        }
    }
}

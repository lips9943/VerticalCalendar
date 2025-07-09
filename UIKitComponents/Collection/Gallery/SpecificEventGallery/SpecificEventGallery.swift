//
//  SEG.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//
import UIKit

open class SpecificEventGallery: UINavigationController {
    private var vm: SEGViewModel!
    private var mainView: SEGViewController!
    private var contentUnavailableView: MyContentUnavailableVC!
    
    public var navigationTitle: String? = nil {
        didSet {
            self.mainView.title = navigationTitle
        }
    }
    public var didPlusButtonTapped: (() -> Void)?
    
    public var eventId: String {
        
    }
    
    open override func viewDidLoad() {
        self.vm = SEGViewModel()
        self.mainView = SEGViewController(vm: vm)
        mainView.delegate = self
        self.contentUnavailableView = MyContentUnavailableVC(
            title: "Access Denied",
            description: "Calendar will appear when access is granted.",
            systemImage: "calendar.badge.exclamationmark")
        super.viewDidLoad()
        
        self.viewControllers = [mainView]
    }
}

extension SpecificEventGallery: SEGViewControllerDelegate {
    func plusButtonTapped() {
        didPlusButtonTapped?()
    }
}

#if DEBUG

#Preview(traits: .defaultLayout) {
    return SpecificEventGallery()
}


#endif

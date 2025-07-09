//
//  SEGViewController.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//


import UIKit
internal import SnapKit
internal import RxSwift

class SEGViewController: UIViewController {
    let disposeBag = DisposeBag()
    var vm: SEGViewModel!
    var galleryView: SEGGalleryView!
    var delegate: SEGViewControllerDelegate?
    
    init(vm: SEGViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUpNavigation()
        setUpGallerView()
    }
}


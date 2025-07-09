//
//  CustomBlurView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/16/25.
//
import UIKit

open class CustomBlurView: UIVisualEffectView {
    private var currentEffect: UIBlurEffect?
    
    public var blurEffect: UIBlurEffect.Style = .systemMaterial {
        didSet {
            effect = UIBlurEffect(style: blurEffect)
        }
    }
    public var isEnable: Bool = true {
        didSet {
            if isEnable {
                self.effect = currentEffect
            } else {
                self.effect = nil
            }
        }
    }
    public override init(effect: UIVisualEffect?) {
        currentEffect = effect as? UIBlurEffect
        super.init(effect: effect)
        setUp()
        
    }
    
    public init() {
        let blurEffect = UIBlurEffect(style: blurEffect)
        currentEffect = blurEffect
        super.init(effect: blurEffect)
        setUp()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}


//#if DEBUG
//import UIKit
//internal import SnapKit
//
//#Preview(traits: .defaultLayout, body: {
//    BlurViewTest()
//})
//
//class BlurViewTest: UIViewController {
//    let blurView = CustomBlurView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let imageView = UIImageView(image: .init(systemName: "trash.slash.square.fill"))
//        view.addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        view.addSubview(blurView)
//        blurView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        blurView.backgroundColor = .clear
//        blurView.blurEffect = .regular
//    }
//}
//
//#endif


//
//  LabelingInEdges.swift
//  My UIKit Conponents
//
//  Created by 고혁준 on 3/24/25.
//

import UIKit
internal import SnapKit

public class LabelWithBorder: UIView {
    public var label: UILabel!
    public init() {
        self.label = UILabel()
        super.init(frame: .zero)
        configuration()
    }
    
    /// 테두리와 라벨의 여백
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15) {
        didSet {
            label.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(insets.left)
                make.trailing.equalToSuperview().inset(insets.right)
                make.top.equalToSuperview().inset(insets.top)
                make.bottom.equalToSuperview().inset(insets.bottom)
            }
        }
    }
    
    /// 테두리의 색상
    public var borderColor: UIColor = .systemGray4 {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    /// 테두리의 두깨
    public var borderWidth: CGFloat = 1.7 {
        didSet { layer.borderWidth = borderWidth }
    }
    /// 엣지의 곡선
    public var cornerRadius: CGFloat = 5.5 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    /// 그림자 위치
    public var shadowOffset: CGSize = CGSize(width: 1.5, height: 3) {
        didSet { layer.shadowOffset = shadowOffset }
    }
    /// 그림자 색상
    public var shadowColor: UIColor = .systemGray {
        didSet { layer.shadowColor = shadowColor.cgColor }
    }
    /// 그림자 투명도
    public var shadowOpacity: Float = 0.6 {
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    /// 그림자 선명도: 낮을 수록 선명해짐.
    public var shadowRadius: CGFloat = 2.7 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelWithBorder {
    private func configuration() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        addSubview(label)
        labelConfigure()
    }
    
    private func labelConfigure() {
        label.backgroundColor = .clear
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insets.left)
            make.trailing.equalToSuperview().inset(insets.right)
            make.top.equalToSuperview().inset(insets.top)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }
    }
    
}


#if DEBUG
#Preview(traits: .defaultLayout, body: {
    LabelingViewController()
})

class LabelingViewController: UIViewController {
    var lwb = LabelWithBorder()
    override func viewDidLoad() {
        self.view.addSubview(lwb)
        lwb.label.text = "Hello, World!"
        lwb.label.font = .systemFont(ofSize: 20)
        lwb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
#endif



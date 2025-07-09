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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelWithBorder {
    private func configuration() {
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1.7
        layer.cornerRadius = 5.5
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
    var label = LabelWithBorder()
    override func viewDidLoad() {
        self.view.addSubview(label)
        label.label.text = "Hello, World!"
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
    }
}
#endif



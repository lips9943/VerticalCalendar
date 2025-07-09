//
//  HDSPreView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/13/25.
//

#if DEBUG
import UIKit
internal import SnapKit

#Preview(traits: .defaultLayout, body: {
    HDSViewController()
})

class HDSViewController: UIViewController {
    let testView = HorizenSelectedCollector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testView)
        testView.posision = .top
    }
}
#endif

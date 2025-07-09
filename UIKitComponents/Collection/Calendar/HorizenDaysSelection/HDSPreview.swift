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
    let testView = HorizenDaysSelection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(testView)
        testView.cellBlur = .systemUltraThinMaterialDark
        testView.isBlurAvailable = false
        testView.isCellBlurAvailable = true
        testView.bgColor = .clear
        testView.cellBGColor = .clear
        testView.cornerRadius = 8
        testView.itemDidSelected = { [weak self] date in
            print(date)
        }
    }
}
#endif

//
//  SegmentTabBarPreview.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/11/25.
//


#if DEBUG
import UIKit
internal import RxFlow

class TestForDelegate: SegmentTabBarDelegate {
    func segmentTabBar(didSelectedSegmentAt index: Int) {
        print(index)
    }
}

private func getTabs(count: Int) -> [SegmentTab] {
    var tabs: [SegmentTab] = []
    let boolian: [Bool] = [true, false]
    let titles = ["우람찬 함성", "무엇을 할까", "배고파", "설정으로 했지", "유인원", "사랑하는", "그림자 살인", "기교", "천박한"]
    let color: [UIColor] = [.red, .green, .blue, .purple, .orange, .brown, .cyan, .magenta, .yellow, .darkGray]
    let images: [String] = ["character.magnify.ko", "number.square", "iphone.gen3.radiowaves.left.and.right", "macpro.gen3.fill", "square.3.layers.3d.middle.filled", "cylinder", "waveform.path.ecg.rectangle.fill", "tugriksign.bank.building", "05.circle", "note", "dryer.circle"]
    for _ in 1...count {
        var tab: SegmentTab
        if boolian.randomElement()! {
            tab = SegmentTab(image: UIImage(systemName: images.randomElement()!)!, selectedImage: UIImage(systemName: images.randomElement()!)!, color: color.randomElement()!, identifier: nil, state: .off) { tab in
                let vc = UIViewController()
                vc.view.backgroundColor = tab.color?.withAlphaComponent(0.06)
                return vc
            }
        } else {
            tab = SegmentTab(title: titles.randomElement()!, color: color.randomElement()!, identifier: nil, state: .off) { tab in
                let vc = UIViewController()
                vc.view.backgroundColor = tab.color?.withAlphaComponent(0.06)
                return vc
            }
        }
        
        tabs.append(tab)
    }
    return tabs
}

#Preview(traits: .defaultLayout, body: {
    getVC()
})

func getVC() -> UIViewController {
    let vc = SegmentTabBarNavigationController(tabs: getTabs(count: 3))
    vc.navigationBarTitle = "sj"
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        vc.moveTab(to: 2)
    }
    
    return vc
}
#endif

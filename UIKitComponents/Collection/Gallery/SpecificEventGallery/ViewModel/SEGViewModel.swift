//
//  SEGViewModel.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//
import UIKit
internal import RxSwift
internal import RxCocoa

class SEGViewModel {
    private let eventId: String
    var pictures: BehaviorRelay<[SEGAsset]> = .init(value: [])
    
    let layoutManager: SEGLayoutManager
    let authManager: SEGAuthManager
    
//    let cacheImages: []
    init(eventId: String) {
        self.eventId = eventId
        layoutManager = SEGLayoutManager()
        authManager = SEGAuthManager()
//        getTestAssets()
    }
}


extension SEGViewModel {
    func sinkAsset(id: String, image: UIImage?, title: String?) {
        var value = pictures.value
        let asset = SEGAsset(id: id, eventId: eventId, title: title ?? "", image: image)
        value.append(asset)
        pictures.accept(value)
    }
    
    func removeAssets(with ids: [String]) {
        var value = pictures.value
        var ids = ids
        value.removeAll { asset in
            if ids.contains(asset.id) {
                ids.removeAll { asset.id == $0 }
                return true
            }
            return false
        }
    }
}
// MARK: - Fetch Services
extension SEGViewModel {
    
}

#if DEBUG
extension SEGViewModel {
    
    
//
//    func getTestAssets()  {
//        var count = 0
//        var result: [SEGAsset] = []
//        while count < 20 {
////            let asset = SEGAsset(id: UUID(), title: "Test \(count)번")
//            result.append(asset)
//            count += 1
//        }
//        pictures.accept(result)
//    }
}
#endif




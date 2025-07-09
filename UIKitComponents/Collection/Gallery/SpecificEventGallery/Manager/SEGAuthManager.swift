//
//  SEGAuthManager.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/12/25.
//

import Photos

struct SEGAuthManager {
    func checkPhotoAuth() -> Bool {
        var result: Bool = false
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                result = true
                break
            case .limited:
                result = true
                break
            @unknown default:
                break
            }
        }
        return result
    }
}

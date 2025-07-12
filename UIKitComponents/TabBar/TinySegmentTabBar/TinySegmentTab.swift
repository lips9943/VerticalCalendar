//
//  TinySegmentTab.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/11/25.
//
import UIKit

public struct TinySegmentTab: TabEntity {
    var viewController: UIViewController!
    var image: UIImage
    var selectedImage: UIImage?
    var color: UIColor?
    
    public init(image: UIImage, selectedImage: UIImage? = nil, color: UIColor? = nil, _ vcConfigure: (inout TinySegmentTab) -> UIViewController) {
        self.image = image
        self.selectedImage = selectedImage
        self.color = color
        self.viewController = vcConfigure(&self)
    }
}

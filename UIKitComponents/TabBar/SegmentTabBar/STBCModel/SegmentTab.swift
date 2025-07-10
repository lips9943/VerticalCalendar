//
//  Tab.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/9/25.
//
import UIKit

public struct SegmentTab {
    var viewController: UIViewController!
    var title: String?
    var color: UIColor?
    var image: UIImage?
    var selectedImage: UIImage?
    var identifier: UIAction.Identifier?
    var attributes: UIAction.Attributes
    var state: UIAction.State
    
    var wasImageSetted: Bool = false
    var wasSelectedImageSetted: Bool = false
    
    init(title: String,
         color: UIColor? = nil,
         identifier: UIAction.Identifier? = nil,
         attributes: UIAction.Attributes = [],
         state: UIAction.State = .off,
         setViewController: (inout SegmentTab) -> UIViewController) {
        self.title = title
        self.color = color
        self.identifier = identifier
        self.attributes = attributes
        self.state = state
        self.viewController = setViewController(&self)
    }
    init(image: UIImage,
         selectedImage: UIImage? = nil,
         color: UIColor?,
         identifier: UIAction.Identifier? = nil,
         attributes: UIAction.Attributes = [],
         state: UIAction.State = .off,
         setViewController: (inout SegmentTab) -> UIViewController) {
        self.image = image
        self.selectedImage = selectedImage
        self.color = color
        self.identifier = identifier
        self.attributes = attributes
        self.state = state
        self.viewController = setViewController(&self)
    }
}

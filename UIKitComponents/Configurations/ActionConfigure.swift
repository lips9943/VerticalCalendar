//
//  ActionConfigure.swift
//  My UIKit Conponents
//
//  Created by 고혁준 on 3/22/25.
//

import UIKit

public struct ActionConfigure {
    private let action: UIAction
    
    public var build: UIAction { action }
    
    public init(identifier: UIAction.Identifier? = nil, handler: @escaping UIActionHandler) {
        action = UIAction(identifier: identifier, handler: handler)
    }
    
    public func setTitle(_ title: String) -> Self {
        action.title = title
        return self
    }
    
    public func setSubtitle(_ subtitle: String?) -> Self {
        action.subtitle = subtitle
        return self
    }
    
    public func setImage(_ image: UIImage?) -> Self {
        action.image = image
        return self
    }
    
    public func setSelectedImage(_ selectedImage: UIImage?) -> Self {
        action.selectedImage = selectedImage
        return self
    }
    
    public func setDiscoverabilityTitle(_ discoverabilityTitle: String?) -> Self {
        action.discoverabilityTitle = discoverabilityTitle
        return self
    }
    
    public func insertAttribute(_ attribute: UIMenuElement.Attributes) -> Self {
        action.attributes.insert(attribute)
        return self
    }
    
    public func setState(_ state: UIMenuElement.State) -> Self {
        action.state = state
        return self
    }
}

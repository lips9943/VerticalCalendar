//
//  MenuConfigure.swift
//  My UIKit Conponents
//
//  Created by 고혁준 on 3/22/25.
//
import UIKit

public class MenuConfigure {
    private var title: String
    private var subTitle: String?
    private var options: UIMenu.Options = []
    private var identifier: UIMenu.Identifier?
    private var image: UIImage?
    private var preferredElementSize: UIMenu.ElementSize = { if #available(iOS 17.0, tvOS 17.0, *) { .automatic } else { .large } }()
    private var children: [UIMenuElement] = []
    
    public init(title: String) {
        self.title = title
    }
    
    public func changeTitle(_ title: String?) -> Self {
        guard let title else { return self }
        self.title = title
        return self
    }
    
    public func setSubTitle(_ subTitle: String?) -> Self {
        guard let subTitle else { return self }
        self.subTitle = subTitle
        return self
    }
    
    public func setOptions(_ options: UIMenu.Options?) -> Self {
        guard let options else { return self }
        self.options.insert(options)
        return self
    }
    
    public func setIdentifier(_ identifier: UIMenu.Identifier?) -> Self {
        guard let identifier else { return self }
        self.identifier = identifier
        return self
    }
    
    public func setImage(_ image: UIImage?) -> Self {
        guard let image else { return self }
        self.image = image
        return self
    }
    
    public func setPreferredElementSize(_ preferredElementSize: UIMenu.ElementSize?) -> Self {
        guard let preferredElementSize else { return self }
        self.preferredElementSize = preferredElementSize
        return self
    }
    
    public func setChildren(_ children: [UIMenuElement]?) -> Self {
        guard let children else { return self }
        self.children = children
        return self
    }
    
    public func addChildAction(identifier: UIAction.Identifier? = nil, handler: @escaping UIActionHandler, setUp: ((ActionConfigure) -> ActionConfigure)? = nil) -> Self {
        var action = ActionConfigure(identifier: identifier, handler: handler)
        if let new = setUp?(action) {
            action = new
        }
        
        children.append(action.build)
        return self
    }
    
    public func build() -> UIMenu {
        UIMenu(title: title, subtitle: subTitle, image: image, identifier: identifier, options: options, preferredElementSize: preferredElementSize, children: children)
    }
}

public extension UIMenu {
    func setConfigure(configure: (MenuConfigure) -> MenuConfigure) -> UIMenu {
        let mc = MenuConfigure(title: self.title)
            .setImage(self.image)
            .setOptions(self.options)
            .setIdentifier(self.identifier)
            .setSubTitle(self.subtitle)
            .setPreferredElementSize(self.preferredElementSize)
            .setChildren(self.children)
        return configure(mc).build()
    }
}

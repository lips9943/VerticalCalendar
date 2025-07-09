//
//  MenuButton.swift
//  My UIKit Conponents
//
//  Created by 고혁준 on 3/22/25.
//
import UIKit
internal import SnapKit
internal import Then

public class MenuButton: UIView {
    private let titleButton: UIButton!
    let menu = MenuConfigure(title: "")
        .build()
    
    var title: String = "title" { didSet {
        titleButton.setTitle(title, for: .normal)
        titleButton.menu = titleButton.menu?.setConfigure { $0.changeTitle(title) }
    }}
    
    public init(button: UIButton) {
        self.titleButton = button
        titleButton.showsMenuAsPrimaryAction = true
        titleButton.menu = menu
        
        super.init(frame: .zero)
        configuration()
    }
    
    public convenience init(type: UIButton.ButtonType) {
        self.init(button: UIButton(type: type))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPrefferedSize(_ size: UIMenu.ElementSize) {
        let menu = titleButton.menu?.setConfigure {
            $0.setPreferredElementSize(size)
        }
        titleButton.menu = menu
    }
    
    public func menuConfigure(_ configure: (MenuConfigure) -> MenuConfigure) {
        guard let currentMenu = titleButton.menu else { return }
        let newMenu = currentMenu.setConfigure(configure: configure)
        titleButton.menu = newMenu
    }
    
    public func addAction(_ identifier: UIAction.Identifier? = nil, handler: @escaping (UIAction) -> Void, configure: (ActionConfigure) -> UIAction) {
        guard let currentMenu = titleButton.menu else { return }
        let action = configure(ActionConfigure(identifier: identifier, handler: handler))
        var items = currentMenu.children
        items.append(action)
        titleButton.menu = currentMenu.replacingChildren(items)
    }
    
    public func addAction(title: String, subtitle: String? = nil, image: UIImage? = nil, action: @escaping (UIAction) -> Void) {
        guard let currentMenu = titleButton.menu else { return }
        let newAction = UIAction(title: title, subtitle: subtitle, image: image, handler: action)
        var items = currentMenu.children
        items.append(newAction)
        titleButton.menu = currentMenu.replacingChildren(items)
    }
    
    public func deleteAction(title: String) {
        guard let currentMenu = titleButton.menu else { return }
        let items = currentMenu.children.filter { $0.title != title }
        titleButton.menu = currentMenu.replacingChildren(items)
    }
}


// MARK: - UIs Configurations
extension MenuButton {
    private func configuration() {
        addSubview(titleButton)
        
        // UIs Configures
        buttonConfiguration()
        
    }
    
    private func buttonConfiguration() {
        titleButton.setTitle("Button", for: .normal)
        
        titleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Replacing Children for Menu
extension MenuButton {
    
}

#if DEBUG
#Preview(traits: .defaultLayout, body: {
    let button = MenuButton(type: .system)
    button.title = "그래"
    button.addAction(title: "원") { action in
        
    }
    button.addAction(title: "투") { action in
        
    }

    button.setPrefferedSize(.automatic)
    return button
})
#endif

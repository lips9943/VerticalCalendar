//
//  MyContentUnavailableView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/20/25.
//
import SwiftUI
import Combine

public class MyContentUnavailableVC: UIHostingController<MyContentUnavailableViewInSwiftUI> {
    public var mainTitle: String = "Title" {
        didSet { rootView.viewModel.title = mainTitle }
    }
    
    public var subTitle: String = "Description" {
        didSet { rootView.viewModel.description = subTitle }
    }
    
    public var systemImage: String = "externaldrive.trianglebadge.exclamationmark" {
        didSet { rootView.viewModel.systemImage = systemImage }
    }
    
    public init(search: Bool = false) {
        super.init(rootView: MyContentUnavailableViewInSwiftUI())
    }
    
    public init(title: String, description: String, systemImage: String) {
        super.init(rootView: MyContentUnavailableViewInSwiftUI(
            title: title, description: description, systemImage: systemImage
        ))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func searchVersion() {
        mainTitle = "No Results"
        subTitle = "Check the spelling of try a new search."
        systemImage = "magnifyingglass"
    }
}

public struct MyContentUnavailableViewInSwiftUI: View {
    @ObservedObject var viewModel: ContentUnavailableViewModel
    
    
    init() {
        self.viewModel = ContentUnavailableViewModel(
            title: "Title",
            description: "Description",
            systemImage: "externaldrive.trianglebadge.exclamationmark")
    }
    
    init(title: String, description: String, systemImage: String) {
        self.viewModel = ContentUnavailableViewModel(
            title: title,
            description: description,
            systemImage: systemImage)
    }
    
    public var body: some View {
        ContentUnavailableView {
            Label(viewModel.title, systemImage: viewModel.systemImage)
        } description: {
            Text(viewModel.description)
        }
    }
}

public class ContentUnavailableViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var systemImage: String

    public init(title: String, description: String, systemImage: String) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
    }
}

#if DEBUG
#Preview(traits: .defaultLayout, body: {
    Preview()
})


func Preview() -> UIViewController {
    let view = MyContentUnavailableVC()
    view.mainTitle = "Hello, World!"
    view.subTitle = "전혀 핼로 하지 않음"
    view.searchVersion()
    return view
}
#endif

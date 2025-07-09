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
    
    public init() {
        super.init(rootView: MyContentUnavailableViewInSwiftUI())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    MyContentUnavailableVC()
})


func Preview() -> UIViewController {
    let view = MyContentUnavailableVC()
    return view
}
#endif

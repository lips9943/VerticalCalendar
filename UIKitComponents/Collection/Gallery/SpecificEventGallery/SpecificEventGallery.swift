//
//  SEG.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//
import UIKit

open class SpecificEventGallery: UINavigationController {
    private var vm: SEGViewModel!
    private var mainView: SEGViewController!
    private var contentUnavailableView: MyContentUnavailableVC!
    private let eventId: String
    
    public var navigationTitle: String? = nil {
        didSet {
            self.mainView.title = navigationTitle
        }
    }
    public var didPlusButtonTapped: (() -> Void)?
    public var isFetchedImageBeforeViewAppear: Bool = false {
        didSet {
            if isFetchedImageBeforeViewAppear {
                
            }
        }
    }
    
    
    public init(eventId: String) {
        self.eventId = eventId
        self.vm = SEGViewModel(eventId: eventId)
        self.mainView = SEGViewController(vm: vm)
        self.contentUnavailableView = MyContentUnavailableVC(
            title: "Access Denied",
            description: "Calendar will appear when access is granted.",
            systemImage: "calendar.badge.exclamationmark")
        super.init(rootViewController: contentUnavailableView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
    }
    
    public func accessStatus(_ value: Bool) {
        if value {
            DispatchQueue.main.async {
                self.viewControllers = [self.mainView]
            }
            
        }
    }
}

// MARK: - CRUD
extension SpecificEventGallery {
    func addImage(id: String, image: UIImage?, title: String? = nil) {
        vm.sinkAsset(id: id, image: image, title: title)
    }
    
    
    
    func deleteImage(ids: [String]) {
        vm.removeAssets(with: ids)
    }
}

extension SpecificEventGallery: SEGViewControllerDelegate {
    func plusButtonTapped() {
        didPlusButtonTapped?()
    }
}

#if DEBUG
import Photos
import PhotosUI

func makeView() -> SpecificEventGallery {
    let view = SpecificEventGallery(eventId: "안녕")
    view.addImage(id: "a", image: UIImage(systemName: "square.and.arrow.up.fill"))
    view.addImage(id: "b", image: UIImage(systemName: "square.and.arrow.up"))
    view.didPlusButtonTapped = {
        let pickerVC = showPickerView(view)
        view.present(pickerVC, animated: true)
    }
    view.accessStatus(true)
    return view
}

func showPickerView(_ delegate: PHPickerViewControllerDelegate) -> PHPickerViewController {
    let configure = PHPickerConfiguration.init(photoLibrary: PHPhotoLibrary.shared())
    
    let picker = PHPickerViewController(configuration: configure)
    picker.delegate = delegate
    return picker
}

extension SpecificEventGallery: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let fetch = PHAsset.fetchAssets(withLocalIdentifiers: results.compactMap { $0.assetIdentifier }, options: nil)
        fetch.enumerateObjects { asset, _, _ in
            PHImageManager.default().requestImage(for: asset, targetSize: .init(width: 100, height: 100), contentMode: .aspectFit, options: nil) { imageForUI, hashableData in
                self.addImage(id: asset.localIdentifier, image: imageForUI)
            }
        }
    }
}
#Preview(traits: .defaultLayout) {
    makeView()
}


#endif

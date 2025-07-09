//
//  SEGNavigationSetUp.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//
import UIKit
import Photos
import PhotosUI

extension SEGViewController: PHPickerViewControllerDelegate {
    func setUpNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentToGallery))
        self.title = "SEG"
    }
    
    @objc func presentToGallery() {
        var photoConfigure = PHPickerConfiguration()
        photoConfigure.selectionLimit = 3
        let photoVC = PHPickerViewController(configuration: photoConfigure)
        photoVC.delegate = self
        
        self.modalPresentationStyle = .automatic
        self.modalTransitionStyle = .coverVertical
        self.present(photoVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        print(results)
    }
    
}


//
//  SEGGallerySetUp.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/12/25.
//


import UIKit

extension SEGViewController {
    func setUpGallerView() {
        galleryView = SEGGalleryView(collectionViewLayout: vm.layoutManager.defaultLayout(), vm: vm)
        setDataSource()
        self.view.addSubview(galleryView)
        galleryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setDataSource() {
        vm.pictures.bind(to: galleryView.rx.items(cellIdentifier: SEGGalleryCell.reuseIdentifier, cellType: SEGGalleryCell.self)) {
            indexPath, model, cell in
            cell.configure(self.vm, asset: model)
            cell.backgroundColor = randomColors.randomElement()
        }.disposed(by: disposeBag)
    }
}

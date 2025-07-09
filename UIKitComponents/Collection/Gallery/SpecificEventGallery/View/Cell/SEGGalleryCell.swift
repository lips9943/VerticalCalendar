//
//  SEGGalleryCell.swift
//  UIKitComponents
//
//  Created by 고혁준 on 6/9/25.
//

import UIKit
internal import SnapKit

class SEGGalleryCell: UICollectionViewCell {
    static let reuseIdentifier = "SEGGalleryCell"
    private var vm: SEGViewModel!
    private var asset: SEGAsset!
    
    private var pic: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pic)
        pic.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ vm: SEGViewModel, asset: SEGAsset) {
        self.vm = vm
        self.asset = asset
        updateImage()
    }
    
    private func updateImage() {
        pic.image = asset.image
    }
}

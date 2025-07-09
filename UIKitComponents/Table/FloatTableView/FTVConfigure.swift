//
//  FTVConfigure.swift
//  UIKitComponents
//
//  Created by 고혁준 on 3/28/25.
//

internal import SnapKit

// MARK: - Header & Footer
extension FloatTableViewController {
    func headerConfigure() {
        headerView.backgroundColor = .systemGray2.withAlphaComponent(0.96)
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        headerView.layer.masksToBounds = true
        headerView.layer.cornerRadius = 10
        headerView.snp.makeConstraints { make in
            headerTopConstraint = make.top.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
            headerHeightConstraint = make.height.equalTo(headerHeight).constraint
        }
    }
    func footerConfigure() {
        footerView.backgroundColor = .systemBrown.withAlphaComponent(0.9)
        footerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        footerView.layer.masksToBounds = true
        footerView.layer.cornerRadius = 10
        footerView.snp.makeConstraints { make in
            footerBottomConstraint = make.bottom.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
            footerHeightConstraint = make.height.equalTo(footerHeight).constraint
        }
    }
}

// MARK: - Configurations
extension FloatTableViewController {
    func configuration() {
        view.addSubview(tableView)
        view.addSubview(headerView)
        view.addSubview(footerView)
        tableViewConfigure()
        headerConfigure()
        footerConfigure()
        bindingUI()
    }
    func tableViewConfigure() {
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

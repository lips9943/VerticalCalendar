//
//  FTVBinding.swift
//  UIKitComponents
//
//  Created by 고혁준 on 3/28/25.
//
internal import SnapKit
internal import RxSwift
internal import RxCocoa
internal import RxGesture
import UIKit
import Combine

// MARK: - Binding
extension FloatTableViewController {
    func bindingUI() {
        // Header & Footer
        headerLayoutAlwaysBindingUI()
        footerLayoutAlwaysBindingUI()
        headerHeightBindingToTableView()
        
        
        //
        endGestureWillResetConstraints()
        isUpperSideBindingToDelegate()
        
        headFootPosition = .HeaderTopFooterBottom
    }
    // MARK: - Layout Binding
    func headerHeightBindingToTableView() {
        Publishers.CombineLatest3(_headerHeight, topSafeAreaInset, betweenTableAndHeader)
            .filter { $0.0 != CGFloat(0) }
            .map { [$0, $1.top, $1.bottom, $2] }
            .removeDuplicates()
            .sink {
                self.tableView.contentInset.top = $0[0] - ($0[1] + $0[2]) + $0[3]
                self.tableView.contentInset.bottom = $0[2]
                self.tableView.setContentOffset(CGPoint(x: 0, y: -($0[0] + $0[1] + $0[2] + $0[3])), animated: false)
            }.store(in: &cancellables)
    }
    func headerLayoutAlwaysBindingUI() {
        _headerHeight.sink { [weak self] value in
            guard let self else { return }
            self.headerView.snp.updateConstraints { make in
                make.height.equalTo(value)
            }
            self.loadViewIfNeeded()
        }
        .store(in: &cancellables)
    }
    func footerLayoutAlwaysBindingUI() {
        _footerHeight.sink { [weak self] value in
            guard let self else { return }
            self.footerView.snp.updateConstraints { make in
                make.height.equalTo(value)
            }
            self.loadViewIfNeeded()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Reach Top
    /// 스크롤 위치가 탑에 도달할 떄 Header와 Footer의 Height를 Max에 맞춥니다.
    func reachTopHeadAndFooterMaxHeight() {
    
    }
    
    // MARK: - Pan Gesture For Constraints
    /// Pan 제스처를 사용하고 손을 때엇을 때 작동.
    
    /// 이 기능은 손을 때었을 때 애니메이션(delegate)가 실행되지 않았을때 Header와 Footer의 최대 또는 최소 Height로 설정 됩니다.
    /// - Tip: 이 기능이 잘 작동하는 지 확인하려면, 손가락을 아주 조금 움직인 후 Header와 Footer가 살짝 움직였을 때, 손을 땝니다. 이 때 Header와 Footer가 원래 위치로 이동한다면 잘 작동하는 것 입니다.
    func endGestureWillResetConstraints() {
        tableView.rx
            .panGesture()
            .when(.ended)
            .filter { _ in self.isAnimating == false }
            .observe(on: MainScheduler.asyncInstance)
            .bind { gesture in
                guard let isScrollMovesUpperSideValue = self.isScrollMovesUpperSide.value else { return }
                let maxHeaderHeight: CGFloat = self._headerHeight.value
                let minHeaderHeight: CGFloat = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                if isScrollMovesUpperSideValue {
                    switch self.headFootPosition {
                    case .HeaderTopFooterBottom:
                        self.headerTopConstraint?.update(inset: 0)
                        self.footerBottomConstraint?.update(offset: 0)
                    case .HeaderHeightFooterBottom:
                        self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                        self.footerBottomConstraint?.update(offset: 0)
                    case .HeaderTopFooterHeight:
                        self.headerTopConstraint?.update(inset: 0)
                        self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    case .HeaderHeightFooterHeight:
                        self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                        self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    }
                } else {
                    switch self.headFootPosition {
                    case .HeaderTopFooterBottom:
                        self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight))
                        self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    case .HeaderHeightFooterBottom:
                        self.headerHeightConstraint?.update(offset: minHeaderHeight)
                        self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    case .HeaderTopFooterHeight:
                        self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight))
                        self.footerHeightConstraint?.update(offset: minFooterHeight)
                    case .HeaderHeightFooterHeight:
                        self.headerHeightConstraint?.update(offset: minHeaderHeight)
                        self.footerHeightConstraint?.update(offset: minFooterHeight)
                    }
                    
                }
                UIView.animate(withDuration: 0.1, delay: 0, options: []) {
                    self.view.layoutIfNeeded()
                }
                
                self.previousScrollOffset = self.tableView.contentOffset.y
                return
            }.disposed(by: disposeBag)
            
    }
    
    // MARK: - Content Offset For Constraints
    /// Content Offset에 관련된 바인딩 메서드.
    
    /// 이 기능은 스크롤 바가 위로 갈 때 true를 Delegate로 전달합니다.
    /// isAnimating이 작동될 때 전달됩니다.
    /// - 외부에서 사용하기 편하게 Delegate로 전달하여 View에 에니메이션을 적용할 수 있음.
    private func isUpperSideBindingToDelegate() {
        isScrollMovesUpperSide
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] value in
                self?.delegate?.contentOffsetDidChange(isScrollMovesUpperSide: value)
            }.store(in: &cancellables)
    }
    
    /// Header와 Footer를 Height를 스크롤 할 때 조절하여 사용자경험을 높입니다.
    func contentOffsetHeaderHeightFooterHeight() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .observe(on: MainScheduler.asyncInstance)
            /// 스크롤이 최상단에 도달하면, 실행되는 기능입니다.
            /// - 도달하는 즉시 Header와 Footer에 크기를 사용자가 설정한 Max Size Height로 설정하여 사용자에게 친숙한 경험을 줍니다.
            /// - 도달하는 즉시 스크롤 Bool Value "isScrollMovesUpperSide"에 nil을 전달하여, 최상단에 도달하더라도 Delegate를 실행하지 않도록 방지합니다.
            .filter {
                if $0 < CGFloat(-(self.headerHeight / 2.5)) {
                    let maxHeaderHeight: CGFloat = self._headerHeight.value
                    let maxFooterHeight: CGFloat = self._footerHeight.value
                    self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                    self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    // top에 도달 했을 때, scroll Bool Value를 nil로 만들어 재사용합니다.
                    
                    self.isScrollMovesUpperSide.send(true)
                    self.previousScrollOffset = $0
                    return false
                }
                return true
            }
            .filter { $0 > CGFloat(-(self.headerHeight / 2.5)) && ((self.tableView.contentSize.height - self.tableView.frame.height)) > $0 }
            .bind { [weak self] offsetY in
                guard let self = self else { return }
                isAnimating = false
                let maxHeaderHeight: CGFloat = self._headerHeight.value
                let minHeaderHeight: CGFloat = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight

                let delta = offsetY - self.previousScrollOffset
                
                var newHeaderHeight = self.headerHeightConstraint?.layoutConstraints.first?.constant ?? maxHeaderHeight
                var newFooterHeight = self.footerHeightConstraint?.layoutConstraints.first?.constant ?? maxFooterHeight
                
                newHeaderHeight -= delta
                newFooterHeight -= delta
                
                newHeaderHeight = max(minHeaderHeight, min(maxHeaderHeight, newHeaderHeight))
                newFooterHeight = max(minFooterHeight, min(maxFooterHeight, newFooterHeight))
                
                // 
                if maxHeaderHeight - ((maxHeaderHeight - minHeaderHeight) * 0.18) >= newHeaderHeight, delta > 0 {
                    self.headerHeightConstraint?.update(offset: minHeaderHeight)
                    self.footerHeightConstraint?.update(offset: minFooterHeight)
                    isAnimating = true
                } else if delta < 0, minHeaderHeight + ((maxHeaderHeight - minHeaderHeight) * 0.24) <= newHeaderHeight {
                    self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                    self.footerHeightConstraint?.update(offset: maxHeaderHeight)
                    isAnimating = true
                }
                
                
                if isAnimating {
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    self.isScrollMovesUpperSide.send(delta < 0)
                    self.previousScrollOffset = offsetY
                    return
                }
                
                self.headerHeightConstraint?.update(offset: newHeaderHeight)
                self.footerHeightConstraint?.update(offset: newFooterHeight)
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    func contentOffsetHeaderHeightFooterBottom() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .observe(on: MainScheduler.asyncInstance)
            /// 스크롤이 최상단에 도달하면, 실행되는 기능입니다.
            /// - 도달하는 즉시 Header와 Footer에 크기를 사용자가 설정한 Max Size Height로 설정하여 사용자에게 친숙한 경험을 줍니다.
            /// - 도달하는 즉시 스크롤 Bool Value "isScrollMovesUpperSide"에 nil을 전달하여, 최상단에 도달하더라도 Delegate를 실행하지 않도록 방지합니다.
            .filter {
                if $0 < CGFloat(-(self.headerHeight / 2.5)) {
                    let maxHeaderHeight: CGFloat = self._headerHeight.value
                    self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                    self.footerBottomConstraint?.update(offset: 0)
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    self.isScrollMovesUpperSide.send(true)
                    self.previousScrollOffset = $0
                    return false
                }
                return true
            }
            .filter { ((self.tableView.contentSize.height - self.tableView.frame.height)) > $0 }
            .bind { [weak self] offsetY in
                guard let self = self else { return }
                isAnimating = false
                let maxHeaderHeight: CGFloat = self._headerHeight.value
                let minHeaderHeight: CGFloat = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                
                let delta = offsetY - self.previousScrollOffset
                
                var newHeaderHeight = self.headerHeightConstraint?.layoutConstraints.first?.constant ?? maxHeaderHeight
                var newFooterBottom = self.footerBottomConstraint?.layoutConstraints.first?.constant ?? self.view.bounds.height
                
                newHeaderHeight -= delta
                newFooterBottom += delta
                
                newHeaderHeight = max(minHeaderHeight, min(maxHeaderHeight, newHeaderHeight))
                newFooterBottom = max(0, min(maxFooterHeight - minFooterHeight, newFooterBottom))
                
                if maxHeaderHeight - ((maxHeaderHeight - minHeaderHeight) * 0.18) >= newHeaderHeight, delta > 0 {
                    self.headerHeightConstraint?.update(offset: minHeaderHeight)
                    self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    isAnimating = true
                } else if delta < 0, minHeaderHeight + ((maxHeaderHeight - minHeaderHeight) * 0.24) <= newHeaderHeight {
                    self.headerHeightConstraint?.update(offset: maxHeaderHeight)
                    self.footerBottomConstraint?.update(offset: 0)
                    isAnimating = true
                }
                
                
                if isAnimating {
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    self.isScrollMovesUpperSide.send(delta < 0)
                    self.previousScrollOffset = offsetY
                    return
                }

                self.headerHeightConstraint?.update(offset: newHeaderHeight)
                self.footerBottomConstraint?.update(offset: newFooterBottom)
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    func contentOffsetHeaderTopFooterHeight() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .observe(on: MainScheduler.asyncInstance)
            /// 스크롤이 최상단에 도달하면, 실행되는 기능입니다.
            /// - 도달하는 즉시 Header와 Footer에 크기를 사용자가 설정한 Max Size Height로 설정하여 사용자에게 친숙한 경험을 줍니다.
            /// - 도달하는 즉시 스크롤 Bool Value "isScrollMovesUpperSide"에 nil을 전달하여, 최상단에 도달하더라도 Delegate를 실행하지 않도록 방지합니다.
            .filter {
                if $0 < CGFloat(-(self.headerHeight / 2.5)) {
                    let maxFooterHeight: CGFloat = self._footerHeight.value
                    self.headerTopConstraint?.update(offset: 0)
                    self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    self.isScrollMovesUpperSide.send(true)
                    self.previousScrollOffset = $0
                    return false
                }
                return true
            }
            .filter { $0 > CGFloat(-(self.headerHeight / 2.5)) && ((self.tableView.contentSize.height - self.tableView.frame.height)) > $0 }
            .bind { [weak self] offsetY in
                guard let self = self else { return }
                isAnimating = false
                let maxHeaderHeight = self._headerHeight.value
                let minHeaderHeight = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                
                let delta = offsetY - self.previousScrollOffset
                var newTopHeader = self.headerTopConstraint?.layoutConstraints.first?.constant ?? 0
                var newFooterHeight = self.footerHeightConstraint?.layoutConstraints.first?.constant ?? maxFooterHeight
                
                newTopHeader -= delta
                newFooterHeight -= delta
                
                
                newTopHeader = max(-(maxHeaderHeight - minHeaderHeight), min(0, newTopHeader))
                newFooterHeight = max(minFooterHeight, min(maxFooterHeight, newFooterHeight))
                
                if -((maxHeaderHeight - minHeaderHeight) * 0.18) >= newTopHeader, delta > 0 {
                    self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight))
                    self.footerHeightConstraint?.update(offset: minFooterHeight)
                    isAnimating = true
                } else if delta < 0, -((maxHeaderHeight - minHeaderHeight) - ((maxHeaderHeight - minHeaderHeight) * 0.24)) <= newTopHeader {
                    self.headerTopConstraint?.update(inset: 0)
                    self.footerHeightConstraint?.update(offset: maxFooterHeight)
                    isAnimating = true
                }
                
                if isAnimating {
                    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
                        self.view.layoutIfNeeded()
                    }
                    
                    self.isScrollMovesUpperSide.send(delta < 0)
                    self.previousScrollOffset = offsetY
                    return
                }
                
                self.headerTopConstraint?.update(inset: newTopHeader)
                self.footerHeightConstraint?.update(offset: newFooterHeight)
                
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
    func contentOffsetHeaderTopFooterBottom() -> Disposable {
        return tableView.rx
            .contentOffset
            .map { $0.y }
            .observe(on: MainScheduler.asyncInstance)
            /// 스크롤이 최상단에 도달하면, 실행되는 기능입니다.
            /// - 도달하는 즉시 Header와 Footer에 크기를 사용자가 설정한 Max Size Height로 설정하여 사용자에게 친숙한 경험을 줍니다.
            /// - 도달하는 즉시 스크롤 Bool Value "isScrollMovesUpperSide"에 nil을 전달하여, 최상단에 도달하더라도 Delegate를 실행하지 않도록 방지합니다.
            .filter {
                if $0 < CGFloat(-(self.headerHeight / 2.5)) {
                    self.headerTopConstraint?.update(offset: 0)
                    self.footerBottomConstraint?.update(offset: 0)
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                        self.view.layoutIfNeeded()
                    }
                    self.isScrollMovesUpperSide.send(true)
                    self.previousScrollOffset = $0
                    return false
                }
                return true
            }
            .filter { $0 > CGFloat(-(self.headerHeight / 2.5)) && ((self.tableView.contentSize.height - self.tableView.frame.height)) > $0 }
            .bind { [weak self] offsetY in
                guard let self else { return }
                isAnimating = false
                let maxHeaderHeight = self._headerHeight.value
                let minHeaderHeight = self.minHeaderHeight
                let maxFooterHeight: CGFloat = self._footerHeight.value
                let minFooterHeight: CGFloat = self.minFooterHeight
                
                let delta = offsetY - self.previousScrollOffset
                var newTopHeader = self.headerTopConstraint?.layoutConstraints.first?.constant ?? 0
                var newFooterBottom = self.footerBottomConstraint?.layoutConstraints.first?.constant ?? self.view.bounds.height
                
                newTopHeader -= delta
                newFooterBottom += delta
                
                newTopHeader = max(-(maxHeaderHeight - minHeaderHeight), min(0, newTopHeader))
                newFooterBottom = max(0, min(maxFooterHeight - minFooterHeight, newFooterBottom))
                
                if -((maxHeaderHeight - minHeaderHeight) * 0.18) >= newTopHeader, delta > 0 {
                    self.headerTopConstraint?.update(inset: -(maxHeaderHeight - minHeaderHeight))
                    self.footerBottomConstraint?.update(offset: maxFooterHeight - minFooterHeight)
                    isAnimating = true
                } else if delta < 0, -((maxHeaderHeight - minHeaderHeight) - ((maxHeaderHeight - minHeaderHeight) * 0.24)) <= newTopHeader {
                    self.headerTopConstraint?.update(inset: 0)
                    self.footerBottomConstraint?.update(offset: 0)
                    isAnimating = true
                }
                
                if isAnimating {
                    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
                        self.view.layoutIfNeeded()
                    }
                    
                    self.isScrollMovesUpperSide.send(delta < 0)
                    self.previousScrollOffset = offsetY
                    return
                }
                
                self.headerTopConstraint?.update(inset: newTopHeader)
                self.footerBottomConstraint?.update(offset: newFooterBottom)
                
                self.view.layoutIfNeeded()
                
                self.previousScrollOffset = offsetY
            }
    }
}

//
//  SpreadTableView.swift
//  UIKitComponents
//
//  Created by 고혁준 on 3/24/25.
//

import UIKit
import Combine
internal import RxSwift
internal import RxCocoa


public class ExpandTableViewCell: UITableViewCell {
    public var isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
    public var cancellables = Set<AnyCancellable>()
    private let disposeBag: DisposeBag = .init()
    
    public func setExpandable(_ tableView: ExpandTableView, indexPath: IndexPath) {
        tableView.selectedIndex
            .map { $0 == indexPath }
            .observe(on: MainScheduler.instance)
            .bind { self.isExpanded.send($0) }
            .disposed(by: disposeBag)
    }
}

public class ExpandTableView: UITableView {
    private let disposeBag: DisposeBag = .init()
    let selectedIndex: BehaviorRelay<IndexPath?> = .init(value: nil)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        configuration()
    }
}


extension ExpandTableView {
    func configuration() {
        self.rx.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            
            // 선택 상태 토글
            let currentIndex = self.selectedIndex.value
            self.selectedIndex.accept(currentIndex == indexPath ? nil : indexPath)
            
            // ✅ 선택된 셀만 애니메이션 적용하여 크기 변경
            UIView.animate(withDuration: 0.3) {
                self.beginUpdates()
                self.endUpdates()
            }
        }.disposed(by: disposeBag)
    }
}


#if DEBUG
internal import SnapKit
internal import Then
#Preview(traits: .defaultLayout, body: {
    let vc = SpreadTableViewController()
    return vc
})

class SpreadTableViewController: UIViewController {
    let bag: DisposeBag = .init()
    let datas = Observable.just(Array(1...100).map(\.description))
    let table = ExpandTableView(style: .insetGrouped)
    override func viewDidLoad() {
        table.register(SpreadTableViewTestCell.self, forCellReuseIdentifier: "cell")
        datas.bind(to: table.rx.items(cellIdentifier: "cell", cellType: SpreadTableViewTestCell.self)) { [weak self] index, model, cell in
            guard let self = self else { return }
            cell.setExpandable(self.table, indexPath: IndexPath(row: index, section: 0))
            cell.configure(text: model)
        }.disposed(by: bag)
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        
    }
}

class SpreadTableViewTestCell: ExpandTableViewCell {
    let label = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        label.text = text
        
        isExpanded.sink {
            if $0 {
                self.label.font = .preferredFont(forTextStyle: .extraLargeTitle)
            } else {
                self.label.font = .preferredFont(forTextStyle: .body)
            }
        }.store(in: &cancellables)
    }
    
    
}
#endif

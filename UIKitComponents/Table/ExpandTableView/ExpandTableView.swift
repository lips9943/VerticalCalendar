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

open class ExpandTableViewCell: UITableViewCell {
    public var isExpanded: CurrentValueSubject<Bool, Never> = .init(false)
    public var cancellables = Set<AnyCancellable>()
    
    override public func prepareForReuse() {
        super.prepareForReuse()
//        isExpanded.send(false)
//        cancellables.removeAll() // Cancellables 초기화
    }
    
    public func setExpandable(_ tableView: ExpandTableView, indexPath: IndexPath) {
        tableView.selectedIndex
            .map { $0 == indexPath }
            .sink { [weak self] in self?.isExpanded.send($0) }
            .store(in: &cancellables)
    }
}

public class ExpandTableView: UITableView {
    private var cancellables = Set<AnyCancellable>()
    private let bag = DisposeBag()
    let selectedIndex = CurrentValueSubject<IndexPath?, Never>(nil)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        configuration()
    }
}

extension ExpandTableView {
    private func configuration() {
        self.rx.itemSelected.bind { [weak self] indexPath in
            guard let self else { return }
            let currentIndex = self.selectedIndex.value
            self.selectedIndex.send(currentIndex == indexPath ? nil : indexPath)
            
            self.beginUpdates()
            self.endUpdates()
        }.disposed(by: bag)
    }
}


#if DEBUG
internal import SnapKit
internal import Then
internal import RxSwift
internal import RxCocoa
#Preview(traits: .defaultLayout, body: {
    let vc = SpreadTableViewController()
    return vc
})

class SpreadTableViewController: UIViewController {
    let bag: DisposeBag = .init()
    let datas = BehaviorRelay(value: Array(1...10).map(\.description))
    let table = ExpandTableView(style: .insetGrouped)
    let addB = UIButton(type: .system)
    let removeB = UIButton(type: .system)
    override func viewDidLoad() {
        view.addSubview(table)
        view.addSubview(addB)
        view.addSubview(removeB)
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        table.register(SpreadTableViewTestCell.self, forCellReuseIdentifier: "cell")
        datas.bind(to: table.rx.items) { tableView, index, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SpreadTableViewTestCell
            cell.configure(text: element)
            cell.setExpandable(self.table, indexPath: IndexPath(row: index, section: 0))
            return cell
        }.disposed(by: bag)
        
        buttonSet()
    }
    
    private func buttonSet() {
        addB.setTitle("add", for: .normal)
        removeB.setTitle("remove", for: .normal)
        addB.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(30)
        }
        removeB.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(30)
        }
        
        addB.rx.tap.bind { [weak self] in
            var currentV = self?.datas.value
            let a = Int(currentV!.last!)! + 1
            currentV!.append("\(a)")
            self?.datas.accept(currentV!)
        }.disposed(by: bag)
        removeB.rx.tap.bind { [weak self] in
            var currentV = self?.datas.value
            currentV?.removeLast()
            self?.datas.accept(currentV!)
        }.disposed(by: bag)
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

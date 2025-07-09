
#if DEBUG
internal import SnapKit
internal import Then
internal import RxSwift
internal import RxCocoa
internal import RxDataSources
import UIKit

#Preview(traits: .defaultLayout, body: {
    let vc = SpreadTableViewController()
    return vc
})

struct SectionOfCustomData {
  var header: String
  var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
  typealias Item = String

  init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

class SpreadTableViewController: UIViewController {
    let bag: DisposeBag = .init()
    let datas: [SectionOfCustomData] = [
        .init(header: "1번", items: ["아","니"]),
        .init(header: "2번", items: ["아","니", "다"]),
    ]
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
        
        table.register(SpreadTableViewTestCell.self, forCellReuseIdentifier: SpreadTableViewTestCell.id)
        bindingUI()
//        datas.bind(to: table.rx.items) { tableView, index, element in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SpreadTableViewTestCell
//            cell.configure(text: element)
//            cell.setExpandable(self.table, indexPath: IndexPath(row: index, section: 0))
//            return cell
//        }.disposed(by: bag)
//        
        buttonSet()
    }
    
    private func bindingUI() {
        Observable
            .just(datas)
            .bind(to: table.rx.items(dataSource: getDataSource()))
            .disposed(by: bag)
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
        
//        addB.rx.tap.bind { [weak self] in
//            var currentV = self?.datas.value
//            let a = Int(currentV!.last!)! + 1
//            currentV!.append("\(a)")
//            self?.datas.accept(currentV!)
//        }.disposed(by: bag)
//        removeB.rx.tap.bind { [weak self] in
//            var currentV = self?.datas.value
//            currentV?.removeLast()
//            self?.datas.accept(currentV!)
//        }.disposed(by: bag)
    }
    
    private func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionOfCustomData> {
        return RxTableViewSectionedReloadDataSource { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpreadTableViewTestCell.id) as? SpreadTableViewTestCell else { return UITableViewCell() }
            cell.configure(text: item)
            cell.setExpandable(self.table, indexPath: indexPath)
            return cell
        }
    }
}

class SpreadTableViewTestCell: ExpandTableViewCell {
    static let id: String = "SpreadTableViewTestCell"
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

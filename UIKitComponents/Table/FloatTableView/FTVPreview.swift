
#if DEBUG
import UIKit
internal import RxSwift
internal import RxCocoa
internal import SnapKit
#Preview(traits: .defaultLayout, body: {
    FloatTableViewControllerTest()
})
class FloatTableViewControllerTest: FloatTableViewController, FloatTableViewDelegate {
    func contentOffsetDidChange(isScrollMovesUpperSide: Bool) {
        print(isScrollMovesUpperSide)
    }
        
    
    
    let bag = DisposeBag()
    
    let refreshView = UIImageView(image: UIImage(systemName: "square.and.arrow.up.circle")).then { view in
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.backgroundColor = .gray
    }
    
    let header = UIView().then {
        $0.backgroundColor = .red.withAlphaComponent(0.3)
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(100, forKey: kCIInputRadiusKey) // 블러 강도 설정
        let label = UILabel()
        label.text = "headerheaderheader"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        $0.layer.backgroundFilters = [blurFilter] // UIView에 필터 적용
    }
    
    let footer = UIView().then {
        $0.backgroundColor = .blue.withAlphaComponent(0.3)
        
        let label = UILabel()
        label.text = "footerfooterfooter"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        $0.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var items: BehaviorRelay<[String]> = .init(value: Array(1...100).map(\.description))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .clear
        refreshControl?.addSubview(refreshView)
        refreshView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        dataConfigure()
        headerView = header
        footerView = footer
        headFootPosition = .HeaderTopFooterHeight
        headerHeight = 150
        minHeaderHeight = 50
        footerHeight = 150
        minFooterHeight = 50
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
extension FloatTableViewControllerTest {
    func dataConfigure() {
        guard let refreshControl else { return }
        tableView.register(FloatTableViewCell.self, forCellReuseIdentifier: "cell")
        items
            .bind(to:  tableView.rx.items(cellIdentifier: "cell", cellType: FloatTableViewCell.self)) { indexPath, element, cell in
                cell.selectionStyle = .none
                cell.title.text = element
            }
            .disposed(by: bag)
        
        // Pull-to-Refresh 이벤트 바인딩
        refreshControl.rx.controlEvent(.valueChanged)
            .flatMapLatest { [weak self] _ -> Observable<[String]> in
                guard let self = self else { return .empty() }
                self.refreshView.isHidden = false
                return self.addDatas().observe(on: MainScheduler.instance)
            }
            .subscribe(onNext: { [weak self] newItems in
                self?.items.accept(newItems)
                self?.refreshView.isHidden = true
                self?.refreshControl?.endRefreshing()
            })
            .disposed(by: bag)
    }
    
    
    func addDatas() -> Observable<[String]> {
        let data = Observable.just(Array(1...100).map(\.description)).delay(.seconds(3), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
        return data
    }
}


class FloatTableViewCell: UITableViewCell {
    let title: UILabel = .init().then { l in
        l.font = .systemFont(ofSize: 17)
        l.textColor = .black
        l.textAlignment = .center
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray3
        addSubview(title)
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

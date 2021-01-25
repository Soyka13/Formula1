//
//  DetailsViewController.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 17.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class DetailsViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var viewModel = PilotsViewModel()
    
    var round = ""
    
    var year = ""
    
    var sections = PublishSubject<[SectionModel]>()
    
    let disposeBag = DisposeBag()
    
    init(year: String, round: String) {
        self.year = year
        self.round = round
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindTableView()
        
        title = "Details"
        
        print("\(year) \(round)")
        
        let dataSource = DetailsViewController.dataSource()
        
        sections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindTableView() {
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        
        viewModel.pilots
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { items in
                let tmp1 = items.compactMap({SectionModelItem.raceSectionItem(item: $0)})
                let tmp2 = items.compactMap({SectionModelItem.pilotSectionItem(item: $0)})
                self.sections.onNext([.raceSection(title: "", items: [tmp1.first ?? .raceSectionItem(item: PilotModel())]), .pilotSection(title: "Results", items: tmp2)])
            }).disposed(by: disposeBag)
        
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonInRound(year: year, round: round))
    }
}

// MARK: - UI Configuration
extension DetailsViewController {
    private func configureTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
}

extension DetailsViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel> {
        return RxTableViewSectionedReloadDataSource<SectionModel>( configureCell: { (dataSources, tableView, ip, _) -> UITableViewCell in
            switch dataSources[ip] {
            
            case .raceSectionItem(item: let item):
                if ip.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.formula1Cell, for: ip) as! Formula1Cell
                    cell.topLabelText = item.raceName + "-" + item.round
                    cell.bottomLabelText = item.raceName + "   " + item.date
                    return cell
                }
                return UITableViewCell()
            case .pilotSectionItem(item: let item):
                if ip.section == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.formula1Cell, for: ip) as! Formula1Cell
                    cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
                    cell.bottomLabelText = item.time
                    return cell
                }
                return UITableViewCell()
            }
            
        },  titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        }
        )    }
}

enum SectionModel {
    case raceSection(title: String, items: [SectionModelItem])
    case pilotSection(title: String, items: [SectionModelItem])
}

enum SectionModelItem {
    case raceSectionItem(item: PilotModel)
    case pilotSectionItem(item: PilotModel)
}


extension SectionModel: SectionModelType {
    typealias Item = SectionModelItem
    
    
    init(original: SectionModel, items: [Item]) {
        switch original {
        
        case .raceSection(title: let title, items: let items):
            self = .raceSection(title: title, items: items)
        case .pilotSection(title: let title, items: let items):
            self = .pilotSection(title: title, items: items)
        }
    }
    
    var items: [SectionModelItem] {
        get {
            switch self {
            
            case .raceSection(title: _, items: let items):
                return items
            case .pilotSection(title: _, items: let items):
                return items.map({$0})
            }
        }
    }
}

extension SectionModel {
    var title: String {
        switch self {
        
        case .raceSection(title: let title, items: _):
            return title
        case .pilotSection(title: let title, items: _):
            return title
        }
    }
}


// MARK: - Table View Data Source and Delegate methods
extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

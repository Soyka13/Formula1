//
//  DetailsViewController.swift
//  Formula1
//
//  Created by Helen Stepaniuk on 26.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class DetailsViewController: UIViewController, UITableViewDelegate {
    
    private var topView: HeaderView = {
        let hv = HeaderView()
        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
    }()
    
    private var headerForTable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Results"
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 1
        return tableView
    }()
    
    var round = ""
    var year = ""
    
    var viewModel = PilotsViewModel()
    
    let disposeBag = DisposeBag()
    
    init(year: String, round: String) {
        self.year = year
        self.round = round
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        topView.addGestureRecognizer(tap)
        title = "Details"
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        bindTableView()
        bindRowSelected()
        
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonInRound(year: year, round: round))
    }
    
    func bindTableView() {
        viewModel.pilots.asObservable().bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { (row,item,cell) in
            self.topView.topLabelText = item.raceName + "-" + item.round
            self.topView.bottomLabelText = item.raceName + "   " + item.date
            cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
            cell.bottomLabelText = item.time
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
    }
    
    private func bindRowSelected() {
        tableView.rx.modelSelected(PilotModel.self)
            .subscribe(onNext: { item in
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                
                let vc = SFSafariViewController(url: URL(string: item.url)!, configuration: config)
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                if let ip = indexPath.element {
                    self.tableView.deselectRow(at: ip, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("!!!!! Touchhhh")
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: URL(string: viewModel.pilots.value[0].raceUrl)!, configuration: config)
        self.present(vc, animated: true)
        
    }
}

// MARK: - UI configuration
extension DetailsViewController {
    private func layout() {
        topView.addLine(position: .bottom, color: .black, width: 1)
        
        view.addSubview(topView)
        view.addSubview(headerForTable)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 100),
            headerForTable.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            headerForTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: headerForTable.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
}

//
//  DriversViewController.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 16.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class PilotsViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    
    let pilotsViewModel = PilotsViewModel()
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bindTableView() {
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        pilotsViewModel.pilots.bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { (row,item,cell) in
            cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
            cell.bottomLabelText = item.raceName
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(PilotModel.self)
            .subscribe(onNext: { item in
                print(item)
                let vc = DetailsViewController(year: item.season, round: item.round)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
            if let ip = indexPath.element {
                self.tableView.deselectRow(at: ip, animated: true)
            }
        }
            .disposed(by: disposeBag)

        pilotsViewModel.fetchData(apiRouterCase: .getPilotsWinnersInSeason(year: "2020"))
    }
}

// MARK: - UI Configuration
extension PilotsViewController {
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

// MARK: - Table View Data Source and Delegate Methods
extension PilotsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        tableView.deselectRow(at: indexPath, animated: true)
//
//    }
}

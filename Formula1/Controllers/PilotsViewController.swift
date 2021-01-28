//
//  PilotsViewController.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 16.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class PilotsViewController: UIViewController, UITableViewDelegate {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = PilotsViewModel()
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        bindTableView()
        bindRowSelected()
        
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonOnPosition(year: "2020", position: "1"))
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
        viewModel.pilots.bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { [weak self](row,item,cell) in
            guard self != nil else { return }
            cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
            cell.bottomLabelText = item.raceName
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
    }
    
    private func bindRowSelected() {
        tableView.rx.modelSelected(PilotModel.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                let vc = DetailsViewController(year: item.season, round: item.round)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self]indexPath in
                guard let self = self else { return }
                if let ip = indexPath.element {
                    self.tableView.deselectRow(at: ip, animated: true)
                }
            }
            .disposed(by: disposeBag)
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

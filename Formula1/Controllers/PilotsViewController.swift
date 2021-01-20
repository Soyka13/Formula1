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
//        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        // MARK: - Delegates
//        tableView.dataSource = nil
//        tableView.delegate = self
        
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
            let driver = item.Driver

            cell.topLabelText = "\(driver.givenName) \(driver.familyName) \(driver.permanentNumber)"
            cell.bottomLabelText = self.pilotsViewModel.raceName ?? ""
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
//
//        pilotsViewModel.raceName.bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { (row,item,cell) in
//            cell.bottomLabelText = String(item)
//        }
//        .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(Result.self).subscribe(onNext: { item in
            print(item)
        }).disposed(by: disposeBag)
        
        pilotsViewModel.fetchNewPilots()
    }
    
//    private func updateUI() {
//        ApiClient.getDrivers()
//            .observe(on: MainScheduler.instance)
//            .subscribe(
//                onNext: { (data) in
//                    print("!!!!!!! Data: \(data)")
//                    let familyName = Observable.of(data.MRData.RaceTable.Races[0].Results[0].Driver.familyName)
//                    let givenName = Observable.of(data.MRData.RaceTable.Races[0].Results[0].Driver.givenName)
//            },
//                onError: { (error) in
//                    print(error)
//                }
//            )
//            .disposed(by: disposeBag)
//    }
    
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
//extension PilotsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.formula1Cell, for: indexPath) as! Formula1Cell
//        cell.topLabelText = "dhjkgfdkjfghdkjfghdkjfhg kjfdkghfdkj kjdfhgkjdfghd"
//        cell.bottomLabelText = "This is a race name!"
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController")
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}


extension PilotsViewController: UITableViewDelegate {
    
}

//
//  DetailsViewController.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 17.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        // MARK: - Delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        
        title = "Details"
        
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

// MARK: - Table View Data Source and Delegate methods
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.formula1Cell, for: indexPath) as! Formula1Cell
            infoCell.topLabelText = "1898-5475-3  jfhdjkfh"
            infoCell.bottomLabelText = "hjdkshf kjdhfkdfj"
            infoCell.accessoryType = .disclosureIndicator
            return infoCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.formula1Cell, for: indexPath) as! Formula1Cell
        cell.topLabelText = "4563874568374568347 48574"
        cell.bottomLabelText = "sdfsdfsdf kjdhfkdfj"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Results"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

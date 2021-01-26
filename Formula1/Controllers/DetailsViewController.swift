//
//  DetailsViewController.swift
//  Formula1
//
//  Created by Helen Stepaniuk on 26.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    var topView: HeaderView = {
        let hv = HeaderView()
        hv.translatesAutoresizingMaskIntoConstraints = false
        return hv
    }()
    
    var headerForTable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Results"
        return label
    }()
    
    var tableView: UITableView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        title = "Details"
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindTableView()
    }
    
    func bindTableView() {
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        viewModel.pilots.asObservable().bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { (row,item,cell) in
            self.topView.topLabelText = item.raceName + "-" + item.round
            self.topView.bottomLabelText = item.raceName + "   " + item.date
            cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
            cell.bottomLabelText = item.raceName
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
        
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonInRound(year: year, round: round))
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

// MARK: - UITableView Delegate methods
extension DetailsViewController: UITableViewDelegate {
}

enum LinePosition {
    case top
    case bottom
}

extension UIView {
    func addLine(position: LinePosition, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}

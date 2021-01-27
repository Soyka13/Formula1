//
//  SearchViewController.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 24.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UITableViewDelegate {
    
    private let stackView = UIStackView()
    
    private let dateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.layer.borderWidth = 1
        tf.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tf.tintColor = .clear
        return tf
    }()
    
    private let datePicker = UIPickerView()
    
    private let roundTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.layer.borderWidth = 1
        tf.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tf.tintColor = .clear
        return tf
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = PilotsViewModel()
    
    private let roundPicker = UIPickerView()
    
    // TODO: - Harcoded part!
    let startYear = 1950
    let currentYear = Calendar.current.component(.year, from: Date())
    var numberOfRounds = 10
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        datePicker.dataSource = self
        datePicker.delegate = self
        
        roundPicker.dataSource = self
        roundPicker.delegate = self
        
        dateTextField.delegate = self
        roundTextField.delegate = self
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        bindTableView()
        bindRowSelected()
        
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonInRound(year: dateTextField.text ?? "1950", round: roundTextField.text ?? "1"))
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
        viewModel.pilots.asObservable().bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { (row,item,cell) in
            cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
            cell.bottomLabelText = item.raceName
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
    }
    
    private func bindRowSelected() {
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
    }
}

// MARK: - UI Configuration
extension SearchViewController {
    private func configureUI() {
        configureStackView()
        createDatePicker()
        createRoundPicker()
        configureTableView()
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25)
        ])
    }
    
    private func createDatePicker() {
        stackView.addArrangedSubview(dateTextField)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endPickingDate))
        toolBar.setItems([doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
        
        dateTextField.text = "\(startYear)"
    }
    
    @objc func endPickingDate() {
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonInRound(year: dateTextField.text ?? "1950", round: roundTextField.text ?? "1"))
        self.view.endEditing(true)
    }
    
    private func createRoundPicker() {
        stackView.addArrangedSubview(roundTextField)
        
        roundPicker.translatesAutoresizingMaskIntoConstraints = false
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endPickingRound))
        toolBar.setItems([doneBtn], animated: true)
        roundTextField.inputAccessoryView = toolBar
        roundTextField.inputView = roundPicker
        
        roundTextField.text = "1"
    }
    
    @objc func endPickingRound() {
        viewModel.fetchData(apiRouterCase: .getPilotsInSeasonInRound(year: dateTextField.text ?? "1950", round: roundTextField.text ?? "1"))
        self.view.endEditing(true)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
}

// MARK: - Picker View Data Source and Delegates methods
extension SearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == datePicker {
            return currentYear - startYear + 1
        } else {
            return 20
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == datePicker {
            return "\(startYear + row)"
        } else {
            return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == datePicker {
            dateTextField.text = "\(startYear + row)"
        } else {
            roundTextField.text = "\(row + 1)"
        }
    }
}

// MARK: - Text Field Delegate methods
extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

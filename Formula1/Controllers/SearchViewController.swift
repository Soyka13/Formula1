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
    
    private let positionTextField: UITextField = {
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
    
    private let positionPicker = UIPickerView()
    
    private let disposeBag = DisposeBag()
    
    private let pilotsViewModel = PilotsViewModel()
    
    private let seasonViewModel = SeasonViewModel()
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        positionPicker.delegate = self
        positionPicker.dataSource = self
        dateTextField.delegate = self
        positionTextField.delegate = self
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(Formula1Cell.self, forCellReuseIdentifier: K.CellIdentifier.formula1Cell)
        
        bindTableView()
        bindRowSelected()
        bindDatePickerView()
        bindPositionPickerView()
        
        pilotsViewModel.fetchData(request: .getPilotsInSeason(year: dateTextField.text ?? String(currentYear)))
        seasonViewModel.fetchData(request: .getSeasonList)
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
        pilotsViewModel.pilots.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: K.CellIdentifier.formula1Cell, cellType: Formula1Cell.self)) { [weak self](row,item,cell) in
                guard self != nil else { return }
                cell.topLabelText = "\(item.givenName) \(item.familyName) \(item.permanentNumber)"
                cell.bottomLabelText = item.raceName
                cell.accessoryType = .disclosureIndicator
            }.disposed(by: disposeBag)
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
            .subscribe { [weak self](indexPath) in
                guard let self = self else { return }
                if let ip = indexPath.element {
                    self.tableView.deselectRow(at: ip, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindDatePickerView() {
        seasonViewModel.seasons.asObservable()
            .bind(to: datePicker.rx.itemTitles) { [weak self](row, element) in
                guard self != nil else { return nil}
                return element.season
        }
            .disposed(by: disposeBag)
        
        datePicker.rx.itemSelected
            .subscribe(onNext: { [weak self](row, value) in
                guard let self = self else { return }
                self.dateTextField.text = self.seasonViewModel.seasons.value[row].season
        })
            .disposed(by: disposeBag)
    }
    
    private func bindPositionPickerView() {
        positionPicker.rx.itemSelected
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.positionTextField.text = item.row == 0 ? "All positions" : String(item.row)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration
extension SearchViewController {
    private func configureUI() {
        configureStackView()
        createDatePicker()
        createPositionPicker()
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
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.translatesAutoresizingMaskIntoConstraints = false

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endPickingDate))
        toolBar.setItems([doneBtn], animated: false)
        dateTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
        
        dateTextField.text = "\(currentYear)"
    }
    
    @objc private func endPickingDate() {
        pilotsViewModel.fetchData(request: .getPilotsInSeason(year: dateTextField.text ?? String(currentYear)))
        self.view.endEditing(true)
    }
    
    private func createPositionPicker() {
        stackView.addArrangedSubview(positionTextField)
        
        positionPicker.translatesAutoresizingMaskIntoConstraints = false
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endPickingPosition))
        toolBar.setItems([doneBtn], animated: true)
        positionTextField.inputAccessoryView = toolBar
        positionTextField.inputView = positionPicker
        
        positionTextField.text = "All positions"
    }
    
    @objc private func endPickingPosition() {
        if positionTextField.text != "All positions" {
            pilotsViewModel.fetchData(request: .getPilotsInSeasonOnPosition(year: dateTextField.text ?? String(currentYear), position: positionTextField.text ?? "1"))
        } else {
            pilotsViewModel.fetchData(request: .getPilotsInSeason(year: dateTextField.text ?? String(currentYear)))
        }
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

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 13
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "All positions" : String(row)
    }
}

// MARK: - Text Field Delegate methods
extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

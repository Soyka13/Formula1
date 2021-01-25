//
//  SearchViewController.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 24.01.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    let stackView = UIStackView()
    
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "fjhsdkfjhsdkfh"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let datePicker = UIPickerView()
    
    let roundTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "fjhsdkfjhsdkfh"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let roundPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
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
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 25)
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
        
        //TODO: - add values to date picker
        
        
    }
    
    @objc func endPickingDate() {
        
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
    }
    
    @objc func endPickingRound() {
        
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

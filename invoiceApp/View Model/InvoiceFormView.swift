//
//  InvoiceFormView.swift
//  invoiceApp
//
//  Created by hanif hussain on 10/01/2024.
//

import UIKit

class InvoiceFormView: UIScrollView, UITextFieldDelegate {

    let invoiceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    var invoiceTitleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(string: "Enter title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return textField
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Generate Invoice"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = .now
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    var addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .backgroundColor: UIColor.white,
            .foregroundColor: UIColor.blue
            //.underlineStyle: NSUnderlineStyle.single
        ]
        let attributedString = NSAttributedString(string: "Add task", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    var customTableView: CreateInvoiceTableView = {
        let tableView = CreateInvoiceTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let paymentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date due: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTaskButton.addTarget(self, action: #selector(addRow), for: .touchUpInside)
        invoiceTitleTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(titleLabel)
        self.addSubview(invoiceTitleLabel)
        self.addSubview(invoiceTitleTextField)
        self.addSubview(customTableView)
        self.addSubview(addTaskButton)
        self.addSubview(paymentDateLabel)
        self.addSubview(datePicker)
        
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            
            invoiceTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            invoiceTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            invoiceTitleLabel.widthAnchor.constraint(equalToConstant: 50),
            invoiceTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            invoiceTitleTextField.topAnchor.constraint(equalTo: invoiceTitleLabel.topAnchor, constant: 5),
            invoiceTitleTextField.leadingAnchor.constraint(equalTo: invoiceTitleLabel.trailingAnchor, constant: 5),
            invoiceTitleTextField.widthAnchor.constraint(equalToConstant: 250),
            invoiceTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            customTableView.topAnchor.constraint(equalTo: invoiceTitleLabel.bottomAnchor, constant: 25),
            customTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            customTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            customTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 450),
            
            addTaskButton.topAnchor.constraint(equalTo: customTableView.bottomAnchor, constant: 10),
            addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            addTaskButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 240),
            addTaskButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            paymentDateLabel.topAnchor.constraint(equalTo: customTableView.bottomAnchor, constant: 10),
            paymentDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            paymentDateLabel.widthAnchor.constraint(equalToConstant: 60),
            paymentDateLabel.heightAnchor.constraint(equalToConstant: 50),
            
            datePicker.topAnchor.constraint(equalTo: customTableView.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: paymentDateLabel.trailingAnchor, constant: 10),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 50),
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func addRow() {
        customTableView.taskCount += 1
        // clear up previous array data so when we repopulate tableview cells we don't have multiple replicas of old data we only need one of each
        customTableView.taskText.removeAll()
        customTableView.costText.removeAll()
        customTableView.tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() { self.endEditing(true) }
    
}

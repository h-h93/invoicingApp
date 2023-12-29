//
//  InvoiceDetailViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 28/11/2023.
//

import UIKit

class InvoiceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    enum TextFieldData: Int {
        
        case nameTextField = 0
        case emailTextField
        case phoneTextField
    }
    
//    weak var delegate: CreateInvoiceViewController!
    var client: ClientDataDBModel?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Generate Invoice"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Task"
        label.font = .systemFont(ofSize: 16, weight: .light, width: .compressed)
        label.textColor = .lightGray
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cost"
        label.font = .systemFont(ofSize: 16, weight: .light, width: .compressed)
        label.textColor = .lightGray
        return label
    }()
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16),
        .backgroundColor: UIColor.black,
        .underlineStyle: NSUnderlineStyle.single
    ]
    
    var addTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .backgroundColor: UIColor.blue,
            //.underlineStyle: NSUnderlineStyle.single
        ]
        let attributedString = NSAttributedString(string: "Add task", attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    var tableContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createInvoice))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreateInvoiceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(titleLabel)
        view.addSubview(tableContainerView)
        tableContainerView.addSubview(tableView)
        
        createTaskEntryFields()

        setupViewConstraints()
        
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            
            tableContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableContainerView.heightAnchor.constraint(equalToConstant: 350),
            
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: -2)
            
        ])
    }
    
    func createTaskEntryFields() {
        var task = UITextField()
        task.borderStyle = .none
        task.translatesAutoresizingMaskIntoConstraints = false
        task.placeholder = "Enter task name"
        task.textColor = .black
        task.setUnderLine()

        
        var cost = UITextField()
        cost.borderStyle = .none
        cost.translatesAutoresizingMaskIntoConstraints = false
        cost.placeholder = "Enter task name"
        cost.textColor = .black
        cost.setUnderLine()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CreateInvoiceTableViewCell
        //cell.selectionStyle = .none
//        var taskTextField = UITextField()
//        taskTextField.tag = indexPath.row
//        taskTextField.translatesAutoresizingMaskIntoConstraints = false
//        taskTextField.placeholder = "Task name"
//        taskTextField.isHidden = false
//        taskTextField.textColor = .black
//        taskTextField.delegate = self
//        cell.contentView.addSubview(taskTextField)
//        NSLayoutConstraint.activate([
//            taskTextField.topAnchor.constraint(equalTo: cell.topAnchor, constant: 8),
//            taskTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
//            taskTextField.heightAnchor.constraint(equalToConstant: 50),
//            taskTextField.widthAnchor.constraint(equalToConstant: 150),
//            taskTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10),
//        ])
//        
//        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    @objc func createInvoice() {
        
    }
}

extension UITextField {

    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}

//
//  InvoiceDetailViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 28/11/2023.
//

import UIKit

class InvoiceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    weak var delegate: CreateInvoiceViewController!
    var client: Client!
    
    var tasks = [Task]()
    var invoice: Invoice!
    
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
    
    var tableContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.dropShadow()
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let paymentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Due date: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    // keep track of our tableview textfields to verif if they've been filled in
    var taskText = [UITextField]()
    var costText = [UITextField]()
    var selectedRow = 0
    var taskDictionary = [String: Double]()
    
    let reuseIdentifier = "Cell"
    
    let id = UUID().uuidString
    
    var taskCount = 1
    
    var paymentDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createInvoice))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreateInvoiceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addTaskButton.addTarget(self, action: #selector(addRow), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(tableContainerView)
        view.addSubview(addTaskButton)
        tableContainerView.addSubview(tableView)
        view.addSubview(paymentDateLabel)
        view.addSubview(datePicker)

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
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: -2),
            
            addTaskButton.topAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: 10),
            addTaskButton.heightAnchor.constraint(equalToConstant: 100),
            addTaskButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 240),
            addTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            paymentDateLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            paymentDateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            paymentDateLabel.widthAnchor.constraint(equalToConstant: 60),
            paymentDateLabel.heightAnchor.constraint(equalToConstant: 50),
            
            datePicker.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: paymentDateLabel.trailingAnchor, constant: 10),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CreateInvoiceTableViewCell
        cell.selectionStyle = .none
        cell.costText.delegate = self
        cell.taskText.delegate = self
        cell.taskText.tag = indexPath.row
        cell.costText.tag = indexPath.row
        cell.costText.keyboardType = .decimalPad
        
        taskText.append(cell.taskText)
        costText.append(cell.costText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        var clientNameLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            //label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Task"
            label.textColor = .lightGray
            return label
        }()
        var amountLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 250, y: 0, width: 50, height: 50))
            //label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Rate"
            label.textColor = .lightGray
            return label
        }()
        
        view.addSubview(clientNameLabel)
        view.addSubview(amountLabel)
        view.backgroundColor = .white
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedRow = textField.tag
        if taskText[selectedRow].text != nil || costText[selectedRow].text != nil {
        }
    }
    
    @objc func addRow() {
        taskCount += 1
        tableView.reloadData()
    }

    @objc func createInvoice() {
        let invoice = Invoice(context: context)
        invoice.client = client
        invoice.date = datePicker.date
        var total = 0.0 as Decimal
        
        for (index, _ ) in taskText.enumerated() {
            if !taskText[index].text!.isEmpty || !costText[index].text!.isEmpty {
                let cost = Decimal(string: costText[index].text!)
                let task = Task(context: context)
                task.amount = cost! as NSDecimalNumber
                total += cost!
                task.task = taskText[index].text!
                task.invoice = invoice
            }
        }
        
        invoice.amount = total as NSDecimalNumber

        if context.hasChanges {
            do {
                try context.save()
                print("here")
            } catch {
                
            }
        }
        
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

extension UITableView {
    /// Reloads a table view without losing track of what was selected.
    func reloadDataSavingSelections() {
        let selectedRows = indexPathsForSelectedRows

        reloadData()

        if let selectedRow = selectedRows {
            for indexPath in selectedRow {
                selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
}

// test@test.com

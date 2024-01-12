//
//  CreateInvoiceTableView.swift
//  invoiceApp
//
//  Created by hanif hussain on 08/01/2024.
//

import UIKit

class CreateInvoiceTableView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // keep track of our tableview textfields to verify if they've been filled in
    var taskText = [UITextField]()
    var costText = [UITextField]()
    var selectedRow = 0
    
    var updateTasks = false
    
    let reuseIdentifier = "Cell"
    
    var tasks = [Task]()
    
    var taskCount = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dropShadow(shadowRadius: 1)
        tableView.register(CreateInvoiceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
    }
    
    func setupView() {
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CreateInvoiceTableViewCell
        cell.selectionStyle = .none
        cell.costText.delegate = self
        cell.taskText.delegate = self
        cell.taskText.addDoneCancelToolbar()
        cell.costText.addDoneCancelToolbar()
        cell.taskText.tag = indexPath.row
        cell.costText.tag = indexPath.row
        cell.costText.keyboardType = .decimalPad
        
        // check if tasks is empty if not then add task details to text fields (user is updating a invoice task list) we need to check to make sure the rows don't exceed tasks count when user adds another task in table if so populate it with the place holder text
        if updateTasks {
            if !tasks.isEmpty && indexPath.row < tasks.count {
                cell.taskText.text = tasks[indexPath.row].task
                cell.costText.text = "\(tasks[indexPath.row].amount)"
            } else if tasks.count == indexPath.row {
                updateTasks = false
            }
        }
        
        taskText.append(cell.taskText)
        costText.append(cell.costText)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let clientNameLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            //label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Task"
            label.textColor = .lightGray
            return label
        }()
        let amountLabel: UILabel = {
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskText.remove(at: indexPath.row)
            costText.remove(at: indexPath.row)
            taskCount -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



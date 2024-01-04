//
//  InvoiceView.swift
//  invoiceApp
//
//  Created by hanif hussain on 30/11/2023.
//

import UIKit

class InvoiceView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    let reuseIdentifier = "Cell"
    var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = .clear
        return tableview
    }()
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Latest Invoices"
        title.textColor = .black
        return title
    }()
    
    var tableHeaderTextOne = "Task"
    var tableHeaderTextTwo = "Cost"
    
    var emptyClientsText = "Get started and add clients"
    
    var clients = [Client]()
    
    var emptyClientsRowCount = 5
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // set view's corener radius and colour
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        self.setupTableView()
    }
    
    func setupTableView() {
        tableView.register(CreateInvoiceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.addSubview(tableView)
        tableView.separatorStyle = .none
        // activate constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clients.isEmpty {
            return emptyClientsRowCount
        } else {
            return clients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
//        if cell == nil {
//            cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CreateInvoiceTableViewCell
        cell.selectionStyle = .none
        if !clients.isEmpty {
            cell.costText.isUserInteractionEnabled = false
            cell.taskText.isUserInteractionEnabled = false
            cell.taskText.text = clients[indexPath.row].name
            let invoice = clients[indexPath.row].invoice.allObjects as! [Invoice]
            cell.costText.text = "\(invoice[0].amount)"

        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = emptyClientsText
                cell.costText.placeholder = ""
                cell.taskText.placeholder = ""
                cell.taskText.isUserInteractionEnabled = false
                cell.costText.isUserInteractionEnabled = false
            } else {
                cell.costText.placeholder = ""
                cell.taskText.placeholder = ""
                cell.taskText.isUserInteractionEnabled = false
                cell.costText.isUserInteractionEnabled = false
            }
        }
        
        // set cell background colour
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        var clientNameLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            //label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Roboto", size: 8)
            label.text = tableHeaderTextOne
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .lightGray
            return label
        }()
        var amountLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 250, y: 0, width: 60, height: 30))
            //label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Roboto", size: 8)
            label.text = tableHeaderTextTwo
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .lightGray
            return label
        }()
        
        view.addSubview(clientNameLabel)
        view.addSubview(amountLabel)
        view.backgroundColor = .white
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

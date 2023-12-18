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
        return title
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // set view's corener radius and colour
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        self.setupTableView()
    }
    
    func setupTableView() {
        self.addSubview(tableView)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // set cell background colour
        cell.backgroundColor = .clear
        // set cell selection colour
        cell.selectionStyle = .blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }

}

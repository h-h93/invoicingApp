//
//  ContactsViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 16/12/2023.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier = "Cell"
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dropShadow()
        return tableView
    }()
    let databaseOperations = DatabaseOperations()
    var clients = [Client]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("com.updateClient"), object: nil)

        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        // Do any additional setup after loading the view.
    }
    
    @objc func reloadData() {
        clients = databaseOperations.fetchClients()
        tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        cell!.selectedBackgroundView = backgroundView
        // set cell background colour
        cell!.backgroundColor = .white
        // set cell selection colour
        cell!.selectionStyle = .default
        cell!.textLabel?.textColor = .black
        if !clients.isEmpty {
            cell!.textLabel?.text = "Name: \n \n\(clients[indexPath.row].name)"
            cell?.textLabel?.numberOfLines = 0
            cell!.detailTextLabel?.text = "Email: \n \n\(clients[indexPath.row].email.lowercased())"
            cell?.detailTextLabel?.textAlignment = .left
            cell?.detailTextLabel?.numberOfLines = 0
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !clients.isEmpty {
            return clients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreateClientViewController()
        vc.previousEmail = clients[indexPath.row].email
        vc.updateContact = true
        vc.scrollView.emailTextField.text = clients[indexPath.row].email
        vc.scrollView.nameTextField.text = clients[indexPath.row].name
        vc.scrollView.phoneNumTextField.text = clients[indexPath.row].number
        // navigationController?.pushViewController(vc, animated: true)
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.modalPresentationStyle = .formSheet
        rootVC.modalTransitionStyle = .crossDissolve
        rootVC.sheetPresentationController?.prefersGrabberVisible = true
        self.present(rootVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

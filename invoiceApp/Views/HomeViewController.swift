//
//  HomeViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 27/11/2023.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var upcomingPayments: InvoiceView = {
        let view = InvoiceView()
        view.titleLabel.text = "Upcoming payments"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dropShadow()
        return view
    }()
    
    var latestInvoiceView: InvoiceView = {
        let view = InvoiceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dropShadow()
        return view
    }()
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    var clients = [Client]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //define the scrollable area by default it is zero
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 800)
        scrollView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInvoice))
        
        view.addSubview(scrollView)
        scrollView.addSubview(latestInvoiceView)
        scrollView.addSubview(upcomingPayments)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            upcomingPayments.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            upcomingPayments.heightAnchor.constraint(equalToConstant: 300),
            upcomingPayments.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            upcomingPayments.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            upcomingPayments.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            
            latestInvoiceView.topAnchor.constraint(equalTo: upcomingPayments.bottomAnchor, constant: 55),
            latestInvoiceView.heightAnchor.constraint(equalToConstant: 300),
            latestInvoiceView.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            latestInvoiceView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            latestInvoiceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            latestInvoiceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100)

        ])
        
        loadInvoices()
    }
    
    func loadInvoices() {
        latestInvoiceView.tableHeaderTextOne = "Client"
        latestInvoiceView.tableHeaderTextTwo = "Amount"
        upcomingPayments.tableHeaderTextOne = "Client"
        upcomingPayments.tableHeaderTextTwo = "Amount"
        do {
            clients = try context.fetch(Client.createFetchRequest())
            let sort = NSSortDescriptor(key: #keyPath(Invoice.date), ascending: true)
            
            latestInvoiceView.clients = self.clients
            upcomingPayments.clients = self.clients
        } catch {
            
        }
        
        if clients.isEmpty {
            upcomingPayments.emptyClientsText = "No upcoming payments found"
            
        }
        
        latestInvoiceView.tableView.reloadData()
        upcomingPayments.tableView.reloadData()
        
//        print(clients.count)
//        let d = clients[0].invoice.allObjects as! [Invoice]
//        let p = d[0].task.allObjects as! [Task]
//        print(p[0].amount)
//        print(clients[0].name)
    }
    
    // disable scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @objc func addInvoice() {
        let vc = CreateInvoiceViewController()
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.modalPresentationStyle = .pageSheet
        rootVC.modalTransitionStyle = .coverVertical
        rootVC.sheetPresentationController?.prefersGrabberVisible = true
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = [.large()]
//            sheet.prefersGrabberVisible = true
//        }
        self.present(rootVC, animated: true)
    }
    


}

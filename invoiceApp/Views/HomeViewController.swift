//
//  HomeViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 27/11/2023.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var upcomingPaymentsView: InvoiceView = {
        let view = InvoiceView()
        view.titleLabel.text = "Upcoming payments"
        view.tableHeaderTextOne = "Client"
        view.tableHeaderTextTwo = "Amount"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dropShadow()
        return view
    }()
    
    var latestInvoiceView: InvoiceView = {
        let view = InvoiceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.emptyClientsText = "Get started and create invoices"
        view.tableHeaderTextOne = "Client"
        view.tableHeaderTextTwo = "Amount"
        view.dropShadow()
        return view
    }()
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let calendar = Calendar.current
    let date = Date()
    
    var upcomingPaymentsList = [Invoice]()
    var latestInvoicesList = [Invoice]()
    var client = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.loadInvoices()
        
        //define the scrollable area by default it is zero
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 800)
        scrollView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInvoice))
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadInvoices), name: NSNotification.Name("com.invoiceCreated"), object: nil)
        
        view.addSubview(scrollView)
        scrollView.addSubview(latestInvoiceView)
        scrollView.addSubview(upcomingPaymentsView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            upcomingPaymentsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            upcomingPaymentsView.heightAnchor.constraint(equalToConstant: 300),
            upcomingPaymentsView.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            upcomingPaymentsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            upcomingPaymentsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            
            latestInvoiceView.topAnchor.constraint(equalTo: upcomingPaymentsView.bottomAnchor, constant: 55),
            latestInvoiceView.heightAnchor.constraint(equalToConstant: 300),
            latestInvoiceView.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            latestInvoiceView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            latestInvoiceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            latestInvoiceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100)
            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.latestInvoiceView.tableView.reloadData()
        self.upcomingPaymentsView.tableView.reloadData()
    }
    
    @objc func loadInvoices() {
        let invoicePredicate = self.date.makeTimestampPredicate(startDate: self.date.startOfDay, endDate: self.date.endOfDay)
        let paymentsPredicate = self.date.makeDatePredicate(startDate: Date.now, endDate: self.calendar.date(byAdding: .day, value: 7, to: Date.now)!)
        
        let latestInvoiceRequest = Invoice.createFetchRequest()
        let upcomingPaymentsRequest = Invoice.createFetchRequest()
        
        let latestInvoiceSort = NSSortDescriptor(key: #keyPath(Invoice.timestamp), ascending: true)
        let upcomingPaymentSort = NSSortDescriptor(key: #keyPath(Invoice.date), ascending: true)
        
        latestInvoiceRequest.predicate = invoicePredicate
        latestInvoiceRequest.sortDescriptors = [latestInvoiceSort]
        upcomingPaymentsRequest.predicate = paymentsPredicate
        upcomingPaymentsRequest.sortDescriptors = [upcomingPaymentSort]
        
        do {
            //clients = try context.fetch(Client.createFetchRequest())
            try self.latestInvoicesList = self.context.fetch(latestInvoiceRequest)
            try self.upcomingPaymentsList = self.context.fetch(upcomingPaymentsRequest)
            
            // pass the filtered invoices to the invoiceview class to display invoices
            self.latestInvoiceView.invoices = self.latestInvoicesList
            self.upcomingPaymentsView.invoices = self.upcomingPaymentsList
            self.latestInvoiceView.tableView.reloadData()
            self.upcomingPaymentsView.tableView.reloadData()
        } catch {
                
        }
        ////        print(clients.count)
        //        let d = clients[0].invoice.allObjects as! [Invoice]
        //        let p = d[0].task.allObjects as! [Task]
        //        print(d.count)
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

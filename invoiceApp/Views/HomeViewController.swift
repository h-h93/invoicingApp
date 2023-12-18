//
//  HomeViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 27/11/2023.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    var invoiceView: InvoiceView = {
        let invoiceView = InvoiceView()
        invoiceView.translatesAutoresizingMaskIntoConstraints = false
        return invoiceView
    }()
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    var upcomingPayments: InvoiceView = {
        let view = InvoiceView()
        view.titleLabel.text = "Upcoming payments"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //define the scrollable area by default it is zero
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 800)
        scrollView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInvoice))
        
        view.addSubview(scrollView)
        scrollView.addSubview(invoiceView)
        scrollView.addSubview(upcomingPayments)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            upcomingPayments.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 150),
            upcomingPayments.heightAnchor.constraint(equalToConstant: 200),
            upcomingPayments.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            upcomingPayments.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            upcomingPayments.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            
            invoiceView.topAnchor.constraint(equalTo: upcomingPayments.bottomAnchor, constant: 150),
            invoiceView.heightAnchor.constraint(equalToConstant: 200),
            invoiceView.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            invoiceView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            invoiceView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            invoiceView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100)

        ])
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

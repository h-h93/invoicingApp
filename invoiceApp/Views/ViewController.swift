//
//  ViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 27/11/2023.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        let invoiceVC = InvoiceViewController()
        invoiceVC.tabBarItem = UITabBarItem(title: "Invoice", image: UIImage(systemName: "banknote"), tag: 1)
        let invoiceNC = UINavigationController(rootViewController: invoiceVC)
        
        let contactsVC = ContactsViewController()
        contactsVC.tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        
        viewControllers = [homeNC, invoiceNC, contactsVC]
        
        
    }


}


//
//  CreateInvoiceViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 28/11/2023.
//

import UIKit
import SwiftData

class CreateClientViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var scrollView: CreateContactView = {
        let scrollView = CreateContactView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Client Information"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    var updateContact = false
    var previousEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name("com.invoiceCreated"), object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addClient))
        
        if updateContact {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteClient))
        }
        
        scrollView.nextButton.addTarget(self, action: #selector(createInvoice), for: .touchUpInside)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        scrollView.nameTextField.delegate = self
        scrollView.emailTextField.delegate = self
        scrollView.phoneNumTextField.delegate = self
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 300)
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        
        setupConstraints()

    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
        ])
    }
    
    @objc func addClient() {
        guard let name = scrollView.nameTextField.text, let email = scrollView.emailTextField.text?.uppercased(), let phone = scrollView.phoneNumTextField.text, !name.isEmpty, !email.isEmpty, !phone.isEmpty else {
            return
        }
        let databaseOp = DatabaseOperations()
        if isValidEmail(email) {
            if updateContact {
                databaseOp.updateClient(currentEmail: previousEmail, name: name, email: email, number: phone)
            } else {
                databaseOp.createNewClient(name: name, email: email, number: phone)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("com.updateClient"), object: nil)
        self.dismissView()
    }
    
    @objc func deleteClient() {
        let databaseOperations = DatabaseOperations()
        let ac = UIAlertController(title: "Are you sure you want to delete: ", message: previousEmail, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { UIAlertAction in
            databaseOperations.deleteClient(email: self.previousEmail)
            NotificationCenter.default.post(name: NSNotification.Name("com.updateClient"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("com.updateComplete"), object: nil)
            self.dismiss(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
        
    }
    
    @objc func createInvoice() {
        guard let name = scrollView.nameTextField.text, let email = scrollView.emailTextField.text?.uppercased(), let phone = scrollView.phoneNumTextField.text, !name.isEmpty, !email.isEmpty, !phone.isEmpty else {
            return
        }
        if isValidEmail(email) {
            let vc = InvoiceDetailViewController()

            vc.email = email
            vc.name = name
            vc.number = phone

            let rootVC = UINavigationController(rootViewController: vc)
            rootVC.modalTransitionStyle = .crossDissolve
            rootVC.modalPresentationStyle = .pageSheet
            rootVC.sheetPresentationController?.prefersGrabberVisible = true
            present(rootVC, animated: true)
            
        }
    }
    
    @objc func dismissView() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    // check if email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    // disable scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

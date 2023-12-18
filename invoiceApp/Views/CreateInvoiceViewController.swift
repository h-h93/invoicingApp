//
//  CreateInvoiceViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 28/11/2023.
//

import UIKit
import SwiftData

class CreateInvoiceViewController: UIViewController, UITextFieldDelegate {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Client Information"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full name"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Phone number"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return textField
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return textField
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 4
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    var phoneNumTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return textField
    }()

    let clientDBOperations = ClientDatabaseOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addClient))
        
        nextButton.addTarget(self, action: #selector(createInvoice), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(fullNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(phoneNumTextField)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            
            fullNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            fullNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            
            nameTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 15),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 100),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 100),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -200),
            
            phoneNumTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 15),
            phoneNumTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            phoneNumTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            nextButton.topAnchor.constraint(equalTo: phoneNumTextField.bottomAnchor, constant: 60),
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 260),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    @objc func addClient() {
        guard let name = nameTextField.text, let email = emailTextField.text, let phone = phoneNumTextField.text, !name.isEmpty, !email.isEmpty, !phone.isEmpty else {
            return
        }
        
        if isValidEmail(email) {
            let clientData = ClientDataDBModel(clientName: name, clientEmail: email, clientNum: phone)
            clientDBOperations.saveData(client: clientData)
        }
        
        print("here")
    }
    
    @objc func createInvoice() {
        guard let name = nameTextField.text, let email = emailTextField.text, let phone = phoneNumTextField.text, !name.isEmpty, !email.isEmpty, !phone.isEmpty else {
            return
        }
        if isValidEmail(email) {
            let vc = InvoiceDetailViewController()
            let rootVC = UINavigationController(rootViewController: vc)
            rootVC.modalTransitionStyle = .crossDissolve
            rootVC.modalPresentationStyle = .pageSheet
            rootVC.sheetPresentationController?.prefersGrabberVisible = true
            present(rootVC, animated: true)
        }
    }
    
    // check if email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CreateContactView.swift
//  invoiceApp
//
//  Created by hanif hussain on 11/01/2024.
//

import UIKit

class CreateContactView: UIScrollView, UITextFieldDelegate, UIPickerViewDelegate {
    
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
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return textField
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
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
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.addDoneCancelToolbar()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        return textField
    }()
    
    var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0.7
        
        self.addSubview(fullNameLabel)
        self.addSubview(emailLabel)
        self.addSubview(phoneNumberLabel)
        self.addSubview(nameTextField)
        self.addSubview(emailTextField)
        self.addSubview(phoneNumTextField)
        self.addSubview(nextButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            
            nameTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 15),
            nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 100),
            emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 100),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -200),
            
            phoneNumTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 15),
            phoneNumTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            phoneNumTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            
            nextButton.topAnchor.constraint(equalTo: phoneNumTextField.bottomAnchor, constant: 60),
            nextButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 280),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
}

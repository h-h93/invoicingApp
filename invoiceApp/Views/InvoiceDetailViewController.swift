//
//  InvoiceDetailViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 28/11/2023.
//

import UIKit
import CoreData

class InvoiceDetailViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let databaseOperations = DatabaseOperations()
    
    // weak var delegate: CreateInvoiceViewController!
    var client: Client?
    var name = String()
    var email = String()
    var number = String()
    
    // track if user is new to alter our storage calls
    var newUser = true
    
    var updateInvoice = false
    
    var oldInvoiceData = Invoice()
    
    var invoiceFormView: InvoiceFormView = {
        let view = InvoiceFormView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var invoiceID = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createInvoice))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        if updateInvoice {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteInvoice))
        }
        // verify is user exists
        verifyUser()
        invoiceFormView.delegate = self
        view.addSubview(invoiceFormView)
        
        setupViewConstraints()
    }
    
    func verifyUser() {
        // check to see if user exists
        newUser = databaseOperations.checkClient(name: name, email: email, number: number)
        // initiate the core data view context
        client = Client(context: context)
        // if this is an update and not a new invoice then populate the text fields and table with captured data
        if updateInvoice {
            invoiceFormView.invoiceTitleTextField.text = oldInvoiceData.title
            invoiceFormView.datePicker.date = oldInvoiceData.date
            let task = oldInvoiceData.task.allObjects as! [Task]
            invoiceFormView.customTableView.tasks = task
            invoiceFormView.customTableView.taskCount = task.count
            invoiceFormView.customTableView.updateTasks = true
            invoiceID = oldInvoiceData.id
            client = oldInvoiceData.client
        } else { // this is a new invoice assign the details to the client instance
            client!.email = email
            client!.name = name
            client!.number = number
        }
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            invoiceFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            invoiceFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            invoiceFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            invoiceFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    @objc func createInvoice() {
        var total = 0.0 as Decimal
        var tasks = [Task]()
        let date = invoiceFormView.datePicker.date
        let titleText = invoiceFormView.invoiceTitleTextField.text ?? "No title"
        // iterate through the task text array and create tasks to apply to invoice
        for (index, _ ) in invoiceFormView.customTableView.taskText.enumerated() {
            if !invoiceFormView.customTableView.taskText[index].text!.isEmpty && !invoiceFormView.customTableView.costText[index].text!.isEmpty {
                let decimalCost = Decimal(string: invoiceFormView.customTableView.costText[index].text!)
                let cost = decimal(with: invoiceFormView.customTableView.costText[index].text!)
                let task = Task(context: context)
                task.amount = cost
                total += decimalCost!
                task.task = invoiceFormView.customTableView.taskText[index].text!
                tasks.append(task)
            }
        }
        
        if updateInvoice {
            databaseOperations.updateInvoice(oldTasks: oldInvoiceData.task.allObjects as! [Task], newTasks: tasks, total: total, date: date, title: titleText, id: oldInvoiceData.id)
        } else if newUser {
            databaseOperations.createNewInvoice(client: client!, date: date, tasks: tasks, total: total, title: titleText, id: invoiceID)
        } else {
            databaseOperations.addInvoiceToRegisteredClient(client: client!, tasks: tasks, total: total, date: date, title: titleText, id: invoiceID)
        }
        NotificationCenter.default.post(name: NSNotification.Name("com.invoiceCreated"), object: nil)
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("com.updateClient"), object: nil)
    }
    
    @objc func deleteInvoice() {
        databaseOperations.deleteInvoice(invoice: oldInvoiceData)
        NotificationCenter.default.post(name: NSNotification.Name("com.updateComplete"), object: nil)
        self.dismiss(animated: true)
    }

    func decimal(with string: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            invoiceFormView.contentInset = .zero
        } else {
            invoiceFormView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        invoiceFormView.scrollIndicatorInsets = invoiceFormView.contentInset
    }
    
    // disable scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

// test@test.com

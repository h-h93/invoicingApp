//
//  InvoiceViewController.swift
//  invoiceApp
//
//  Created by hanif hussain on 27/11/2023.
//

import UIKit

class InvoiceViewController: UIViewController, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let databaseOps = DatabaseOperations()
    
    var allInvoicesView: InvoiceView = {
        let view = InvoiceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Results"
        view.emptyInvoicesRowCount = 0
        view.dropShadow(shadowRadius: 1)
        return view
    }()
    
    let enterRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "From: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    var fromRangeTextField: DateTextField = {
        let textField = DateTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.tag = 1
        return textField
    }()
    
    let toRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "To: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    var toRangeTextField: DateTextField = {
        let textField = DateTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.tag = 2
        textField.datePicker.minimumDate = .now
        return textField
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.isUserInteractionEnabled = true
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var invoices = [Invoice]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        applyButton.addTarget(self, action: #selector(filterSearch), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(filterSearch), name: NSNotification.Name("com.invoiceCreated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filterSearch), name: NSNotification.Name("com.updateComplete"), object: nil)
        allInvoicesView.tableView.delegate = self
        setupView()
    }
    
    func setupView() {
        let date = Date()
        getInvoices(startDate: date.startOfMonth, endDate: date.endOfMonth)
        fromRangeTextField.text = ("\(date.startOfMonth.formatted(date: .numeric, time: .omitted))")
        toRangeTextField.text = ("\(date.endOfMonth.formatted(date: .numeric, time: .omitted))")
        view.addSubview(enterRangeLabel)
        view.addSubview(fromRangeTextField)
        view.addSubview(toRangeLabel)
        view.addSubview(toRangeTextField)
        view.addSubview(allInvoicesView)
        view.addSubview(applyButton)
        setupConstraints()
    }
    
    func getInvoices(startDate: Date, endDate: Date) {
        let date = Date()
        do {
            let predicate = date.makeDatePredicate(startDate: startDate, endDate: endDate)
            let request = Invoice.createFetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(Invoice.date), ascending: false)
            
            request.predicate = predicate
            request.sortDescriptors = [sort]
            
            try invoices = context.fetch(request)
            
            allInvoicesView.invoices = invoices
            allInvoicesView.tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            enterRangeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            enterRangeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            enterRangeLabel.heightAnchor.constraint(equalToConstant: 50),
            enterRangeLabel.widthAnchor.constraint(equalToConstant: 40),
            
            fromRangeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            fromRangeTextField.leadingAnchor.constraint(equalTo: enterRangeLabel.trailingAnchor, constant: 1),
            fromRangeTextField.heightAnchor.constraint(equalToConstant: 40),
            fromRangeTextField.widthAnchor.constraint(equalToConstant: 100),
            
            toRangeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toRangeLabel.leadingAnchor.constraint(equalTo: fromRangeTextField.trailingAnchor, constant: 15),
            toRangeLabel.heightAnchor.constraint(equalToConstant: 50),
            toRangeLabel.widthAnchor.constraint(equalToConstant: 25),
            
            toRangeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toRangeTextField.leadingAnchor.constraint(equalTo: toRangeLabel.trailingAnchor, constant: 1),
            toRangeTextField.heightAnchor.constraint(equalToConstant: 40),
            toRangeTextField.widthAnchor.constraint(equalToConstant: 100),
            
            applyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            applyButton.leadingAnchor.constraint(equalTo: toRangeTextField.trailingAnchor, constant: 1),
            applyButton.heightAnchor.constraint(equalToConstant: 40),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            allInvoicesView.topAnchor.constraint(equalTo: enterRangeLabel.bottomAnchor, constant: 10),
            allInvoicesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            allInvoicesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            allInvoicesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func filterSearch() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let fromDate = dateFormatter.date(from: fromRangeTextField.text!) else { return }
        guard let toDate = dateFormatter.date(from: toRangeTextField.text!) else { return }
        getInvoices(startDate: fromDate, endDate: toDate)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !invoices.isEmpty {
            let vc = InvoiceDetailViewController()
            let rootVC = UINavigationController(rootViewController: vc)
            rootVC.modalPresentationStyle = .pageSheet
            rootVC.modalTransitionStyle = .crossDissolve
            rootVC.sheetPresentationController?.prefersGrabberVisible = true
            vc.updateInvoice = true
            vc.oldInvoiceData = invoices[indexPath.row]
            vc.email = invoices[indexPath.row].client.email
            vc.name = invoices[indexPath.row].client.name
            vc.number = invoices[indexPath.row].client.number
            vc.invoiceFormView.datePicker.minimumDate = .distantPast
            vc.invoiceFormView.datePicker.date = invoices[indexPath.row].date
            vc.newUser = false
            vc.invoiceID = invoices[indexPath.row].id
            
            present(rootVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

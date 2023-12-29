//
//  CreateInvoiceTableViewCell.swift
//  invoiceApp
//
//  Created by hanif hussain on 27/12/2023.
//

import UIKit

class CreateInvoiceTableViewCell: UITableViewCell {
    var taskText: UITextField = {
        let task = UITextField()
        task.borderStyle = .none
        task.translatesAutoresizingMaskIntoConstraints = false
        task.placeholder = "Enter task name"
        task.textColor = .black
        task.backgroundColor = .clear
        task.setUnderLine()
        return task
    }()
    var costText: UITextField = {
        let cost = UITextField()
        cost.borderStyle = .none
        cost.translatesAutoresizingMaskIntoConstraints = false
        cost.placeholder = "Enter cost"
        cost.textColor = .black
        cost.backgroundColor = .clear
        cost.setUnderLine()
        return cost
    }()
    
    var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(view)
        view.addSubview(taskText)
        view.addSubview(costText)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            taskText.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            taskText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskText.heightAnchor.constraint(equalToConstant: 50),
            taskText.widthAnchor.constraint(equalToConstant: 150),
            taskText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            costText.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            costText.leadingAnchor.constraint(equalTo: taskText.trailingAnchor, constant: 100),
            taskText.heightAnchor.constraint(equalToConstant: 50),
            costText.widthAnchor.constraint(equalToConstant: 150),
            costText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

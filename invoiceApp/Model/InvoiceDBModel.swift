//
//  InvoiceDBModel.swift
//  invoiceApp
//
//  Created by hanif hussain on 28/11/2023.
//

import Foundation
import SwiftData

@Model
class InvoiceDBModel {
    @Attribute(.unique) var invoiceID: String
    var customerName: String
    var date: Date
    var paymentDate: Date
    var task: [String: Double]
    var paymentAmount: Double
    
    init(invoiceID: String, customerName: String, date: Date, paymentDate: Date, task: [String : Double], paymentAmount: Double) {
        self.invoiceID = invoiceID
        self.customerName = customerName
        self.date = date
        self.paymentDate = paymentDate
        self.task = task
        self.paymentAmount = paymentAmount
    }
    
}

enum invoices {
    case InvoiceDBModel
}

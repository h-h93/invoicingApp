//
//  InvoiceDatabaseOperation.swift
//  invoiceApp
//
//  Created by hanif hussain on 16/12/2023.
//

import Foundation
import SwiftData

class InvoiceDatabaseOperation {
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            container = try ModelContainer(for: InvoiceDBModel.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
}

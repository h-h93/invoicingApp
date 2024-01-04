//
//  Task+CoreDataProperties.swift
//  invoiceApp
//
//  Created by hanif hussain on 02/01/2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var task: String
    @NSManaged public var invoice: Invoice

}

extension Task : Identifiable {

}

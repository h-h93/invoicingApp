//
//  Invoice+CoreDataProperties.swift
//  invoiceApp
//
//  Created by hanif hussain on 01/01/2024.
//
//

import Foundation
import CoreData


extension Invoice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var date: Date?
    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var task: NSSet?
    @NSManaged public var client: Client?

}

// MARK: Generated accessors for task
extension Invoice {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

extension Invoice : Identifiable {

}

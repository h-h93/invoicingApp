//
//  Invoice+CoreDataProperties.swift
//  invoiceApp
//
//  Created by hanif hussain on 11/01/2024.
//
//

import Foundation
import CoreData


extension Invoice {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String
    @NSManaged public var client: Client
    @NSManaged public var task: NSSet

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

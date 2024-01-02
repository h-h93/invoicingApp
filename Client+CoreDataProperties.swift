//
//  Client+CoreDataProperties.swift
//  invoiceApp
//
//  Created by hanif hussain on 02/01/2024.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var number: String?
    @NSManaged public var invoice: NSSet?

}

// MARK: Generated accessors for invoice
extension Client {

    @objc(addInvoiceObject:)
    @NSManaged public func addToInvoice(_ value: Invoice)

    @objc(removeInvoiceObject:)
    @NSManaged public func removeFromInvoice(_ value: Invoice)

    @objc(addInvoice:)
    @NSManaged public func addToInvoice(_ values: NSSet)

    @objc(removeInvoice:)
    @NSManaged public func removeFromInvoice(_ values: NSSet)

}

extension Client : Identifiable {

}

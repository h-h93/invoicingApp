//
//  DatabaseOperations.swift
//  invoiceApp
//
//  Created by hanif hussain on 05/01/2024.
//

import Foundation
import CoreData
import UIKit

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

var name = String()
var email = String()
var number = String()

var existingClientData = [Invoice]()

class DatabaseOperations {
    
    func createNewClient(name: String, email: String, number: String) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let client = Client(context: context)
        client.name = name
        client.email = email
        client.number = number
        print(email)
        do {
            try context.save()
        } catch {
            print("Error creating a new client: \(error.localizedDescription)")
        }
    }
    
    func deleteClient(email: String) {
        let request = Client.createFetchRequest()
        request.predicate = NSPredicate(format: "email ==%@", argumentArray: [email])
        do {
            let results = try context.fetch(request)
            if results.count != 0 {
                deleteAllInvoices(invoice: results[0].invoice)
                context.delete(results[0])
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateClient(currentEmail: String, name: String, email: String, number: String) {
        let request = Client.createFetchRequest()
        request.predicate = NSPredicate(format: "email ==%@", argumentArray: [currentEmail])
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                results.first?.name = name
                results.first?.email = email
                results.first?.number = number
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchClients() -> [Client] {
        let request = Client.createFetchRequest()
        var clients = [Client]()
        do {
            clients = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return clients
    }
    
    func checkClient(name: String, email: String, number: String) -> Bool {
        let request = NSFetchRequest<Client>(entityName: "Client")
        request.predicate = NSPredicate(format: "email == %@", email)
        var exists = false
        do {
            let existingClient = try context.fetch(request)
            if existingClient.first?.email == nil {
                exists = true
            } else {
                exists = false
                let data = existingClient.first?.invoice.allObjects as! [Invoice]
                existingClientData = data
                print(data)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return exists
    }
    
    
    func createNewInvoice(client: Client, date: Date, tasks: [Task], total: Decimal, title: String, id: String) {
        let invoice = Invoice(context: context)
        
        invoice.id = id
        invoice.title = title
        invoice.date = date
        invoice.timestamp = Date.now
        print(invoice.timestamp)
        
        for (index, _ ) in tasks.enumerated() {
            if !tasks[index].task.isEmpty {
                let task = Task(context: context)
                task.task = tasks[index].task
                task.amount = tasks[index].amount
                task.invoice = invoice
            }
        }
        
        invoice.amount = total as NSDecimalNumber
        
        client.addToInvoice(invoice)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addInvoiceToRegisteredClient(client: Client, tasks: [Task], total: Decimal, date: Date, title: String, id: String) {
        let invoice = NSEntityDescription.insertNewObject(forEntityName: "Invoice", into: context) as! Invoice
        
        invoice.id = id
        invoice.title = title
        invoice.date = date
        invoice.timestamp = Date.now
        
        for (index, _ ) in tasks.enumerated() {
            if !tasks[index].task.isEmpty {
                let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
                task.task = tasks[index].task
                task.amount = tasks[index].amount
                invoice.addToTask(task)
            }
        }
        
        invoice.amount = total as NSDecimalNumber
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // add the clients old and newly created invoices and merge them
        existingClientData.append(invoice)
        let set1 = NSSet(array: existingClientData)
        client.invoice = set1
        
        do {
            try context.save()
        } catch let error {
            print("Could not save. \(error.localizedDescription)")
        }
    }
    
    func updateInvoice(oldTasks: [Task], newTasks: [Task], total: Decimal, date: Date, title: String, id: String) {
        let request = Invoice.createFetchRequest()
        request.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
        
        do {
            let results = try context.fetch(request)
            if results.count != 0 {
                for oldTask in oldTasks {
                    results.first?.removeFromTask(oldTask)
                }
                
                for newTask in newTasks {
                    results.first?.addToTask(newTask)
                }
                results.first?.amount = total as NSDecimalNumber
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                //deleteOldTasks(oldTasks: oldTasks)
                try context.save()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // not needed for now as replacing tasks and merging seems to delete old data
    func deleteOldTasks(oldTasks: [Task]) {
        //        let request = Task.createFetchRequest()
        //
        //        do {
        //            let results = try context.fetch(request)
        //            for result in results {
        //                for oldTask in oldTasks {
        //                    if oldTask == result {
        //                        context.delete(result)
        //                    }
        //                }
        //            }
        //
        //            try context.save()
        //        } catch {
        //            print(error.localizedDescription)
        //        }
    }
    
    func deleteInvoice(invoice: Invoice) {
        let request = Invoice.createFetchRequest()
        let client = invoice.client
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [invoice.id])
        
        do {
            let results = try context.fetch(request)
            if results.count != 0 {
                context.delete(results.first!)
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        cleanup()
    }
    
    func deleteAllInvoices(invoice: NSSet) {
        let request = Invoice.createFetchRequest()
        
        do {
            do {
                let results = try context.fetch(request)
                if results.count != 0 {
                    for invoices in results {
                        context.delete(invoices)
                    }
                    try context.save()
                }
            } catch {
                print(error.localizedDescription)
            }
            
            cleanup()
        }
    }
    
    func cleanup() {
        let request = Client.createFetchRequest()
        request.predicate = NSPredicate(format: "email == %@", argumentArray: [nil])
        
        do {
            let results = try context.fetch(request)
            if results.count != 0 {
                for i in results {
                    context.delete(i)
                }
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}




//
//  DatabaseOperations.swift
//  invoiceApp
//
//  Created by hanif hussain on 16/12/2023.
//

import Foundation
import SwiftData

class ClientDatabaseOperations {
    
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            container = try ModelContainer(for: ClientDataDBModel.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    
    func saveData(client: ClientDataDBModel) {
        if let context {
            context.insert(client)
        }
    }
    
    func fetchClients(onCompletion:@escaping([ClientDataDBModel]?,Error?)->(Void)) {
        let descriptor = FetchDescriptor<ClientDataDBModel>(sortBy: [SortDescriptor<ClientDataDBModel>(\.clientName)])
        if let context {
            do {
                let data = try context.fetch(descriptor)
                onCompletion(data, nil)
            } catch {
                onCompletion(nil, error)
            }
        }
    }
    
    func updateClient(client: ClientDataDBModel) {
        
    }
    
    func deleteClient(client: ClientDataDBModel) {
        let clientToBeDeleted = client
        if let context {
            context.delete(clientToBeDeleted)
        }
    }
}

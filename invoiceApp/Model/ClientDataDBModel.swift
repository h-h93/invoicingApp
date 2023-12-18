//
//  ClientDataDBModel.swift
//  invoiceApp
//
//  Created by hanif hussain on 29/11/2023.
//

import Foundation
import SwiftData

@Model
class ClientDataDBModel {
    var clientName: String
    @Attribute(.unique) var clientEmail: String
    var clientNum: String
    
    init(clientName: String, clientEmail: String, clientNum: String) {
        self.clientName = clientName
        self.clientEmail = clientEmail
        self.clientNum = clientNum
    }
}

enum clients {
    case ClientDataDBModel
}

//
//  AccountService.swift
//  Poodle
//
//  Created by Luca Archidiacono on 03.12.2023.
//

import Foundation

struct Account {
    struct Details {
        let host: String
        let port: Int
    }
    
    /// Represents the email.
    let xmppID: String
    let password: String
    let details: Details?
}

actor AccountService {
    private let defaults = UserDefaults.standard
    
    let defaultAccount: Account? = nil
    
    init() {
        if let username = defaults.string(forKey: "username") { 
        }
    }
    
    func getMainAccount() {
        
    }
}

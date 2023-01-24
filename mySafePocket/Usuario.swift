//
//  Usuario.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 23/01/2023.
//

import Foundation

class Usuario: Codable {
    fileprivate var password: Int
    
    init (password: Int) {
        self.password = password
    }
    
    func cambiaPassword(password: Int) {
        self.password = password
    }
    
    func getPassword() -> Int{
        return self.password
    }
}

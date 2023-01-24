//
//  DocumentsDirectory.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//
//  Gasto.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import Foundation

struct Gasto: Codable, Identifiable {
    enum errores: Error, Codable {
        case montoInvalido
    }
    let id: UUID
    let descripcion: String
    let monto: Double
    let etiqueta: String
    
    init(descripcion: String, monto: Double, etiqueta: String) throws {
        self.id = UUID()
        self.descripcion = descripcion
        if monto > 0 {
            self.monto = monto
        } else {
            throw errores.montoInvalido
        }
        if (etiqueta == "Gasto Fijo" || etiqueta == "Compra" || etiqueta == "Inversion") {
            self.etiqueta = etiqueta
        } else {
            fatalError("la etiqueta del gasto esta mal") // esto es imposible q pase, se usa picker
        }
    }
}

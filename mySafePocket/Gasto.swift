//
//  Gasto.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import Foundation
import SwiftUI

struct Gasto: Codable, Identifiable {
    enum errores: Error, Codable {
        case montoInvalido
    }
    let id: UUID
    let descripcion: String
    let monto: Double
    let etiqueta: String
    let fecha: Date
    let imagen: Data? // guardo la informacion de la imagen porq la foto no es codable
    
    init(descripcion: String, monto: Double, etiqueta: String, fecha: Date, imagen: Data?) throws {
        self.id = UUID()
        self.descripcion = descripcion
        self.fecha = fecha
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
        self.imagen = imagen
    }
}

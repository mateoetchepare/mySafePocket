//
//  GastosViewModel.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

@MainActor class GastosViewModel: ObservableObject {
    @Published var items: [Gasto]
    let directorio = FileManager.documentsDirectory.appendingPathComponent("gastosUsuario")
    let etiquetas: [String] = ["Gasto Fijo", "Inversion", "Compra"]
    let colores: [Color] = [Color.red, Color.blue, Color.orange]
    //var texto: String = ""
    /*var gastosFiltradosPorNombre: [Gasto] {
     if items.isEmpty {
     return []
     } else {
     return items.filter { $0.descripcion.localizedCaseInsensitiveContains(texto) }
     }
     }
     */
    
    func agregaGasto(descripcion: String, monto: Double,  etiqueta: String, fecha: Date) -> Bool? {
        do {
            let nuevoGasto = try Gasto(descripcion: descripcion, monto: monto, etiqueta: etiqueta, fecha: fecha) // esto puede dar error
            items.append(nuevoGasto) // si returna nil esta todo bien, si returna false dio error
            guardar()
        } catch {
            return false
        }
        return nil
    }
    
    func borraGastos(at offsets: IndexSet)  {
        items.remove(atOffsets: offsets)
        guardar()
    }
    
    init() { // esto es para recibir datos del directorio
        do {
            let data = try Data(contentsOf: directorio)
            items = try JSONDecoder().decode([Gasto].self, from: data)
        } catch {
            items = []
        }
    }
    
    func guardar() { // esto es para escribir datos en el directorio
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: directorio)
        } catch {
            fatalError("Se rompe al guardar los datos")
        }
    }
    
    func calcularParametrosGrafico() -> ([Double], [String], [Color]) {
        var valores: [Double] = [0.0, 0.0, 0.0]
        
        for gastos in items {
            switch gastos.etiqueta {
            case "Gasto Fijo":
                valores[(etiquetas.firstIndex(of: "Gasto Fijo"))!] += gastos.monto
            case "Inversion":
                valores[(etiquetas.firstIndex(of: "Inversion"))!] += gastos.monto
            case "Compra":
                valores[(etiquetas.firstIndex(of: "Compra"))!] += gastos.monto
            default:
                break
            }
        }
        
        return (valores, etiquetas, colores)
    }
}

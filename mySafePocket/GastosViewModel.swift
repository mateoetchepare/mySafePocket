//
//  GastosViewModel.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import PhotosUI
import SwiftUI

@MainActor class GastosViewModel: ObservableObject {
    @Published var items: [Gasto]
    let directorio = FileManager.documentsDirectory.appendingPathComponent("gastosUsuario")
    let etiquetas: [String] = ["Gasto Fijo", "Inversion", "Compra"]
    let colores: [Color] = [Color.red, Color.blue, Color.orange]
    
    @Published var datos: Data?
    @Published var seleccionFoto: PhotosPickerItem? {
        didSet {
            if let seleccionFoto {
                loadTransferable(from: seleccionFoto)
                print("se ejecuta")
            }
        }
    }
    
    //var texto: String = ""
    /*var gastosFiltradosPorNombre: [Gasto] {
     if items.isEmpty {
     return []
     } else {
     return items.filter { $0.descripcion.localizedCaseInsensitiveContains(texto) }
     }
     }
     */
    
    private func loadTransferable(from seleccionFoto: PhotosPickerItem) {
        seleccionFoto.loadTransferable(type: Data.self) { resultado in
            DispatchQueue.main.async {
                guard seleccionFoto == self.seleccionFoto else {
                    return
                }
                switch resultado {
                case .success(let data):
                    let uiImage = UIImage(data: data!)
                    self.datos = uiImage!.pngData()
                    print("entro aca hdp")
                case .failure:
                    fatalError("No se sabe que paso con la carga de la imagen")
                }
            }
        }
    }
    
    func agregaGasto(descripcion: String, monto: Double,  etiqueta: String, fecha: Date, imagen: Data?) -> Bool? {
        do {
            let nuevoGasto = try Gasto(descripcion: descripcion, monto: monto, etiqueta: etiqueta, fecha: fecha, imagen: imagen) // esto puede dar error
            items.append(nuevoGasto) // si returna nil esta todo bien, si returna false dio error
            guardar()
            ordena()
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
            ordena()
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
    
    private func ordena() {
        items.sort {
            $0.fecha.timeIntervalSince1970 > $1.fecha.timeIntervalSince1970
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
    
    func retornaImagen(datos: Data?) -> Image {
        if datos != nil {
            let uiImage = UIImage(data: datos!)
            let imagen = Image(uiImage: uiImage!)
            return imagen
        } else {
            return Image(systemName: "questionmark.app.fill")
        }
    }
}

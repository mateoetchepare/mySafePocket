//
//  GastosFila.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

struct GastosFila: View {
    
    let gasto: Gasto
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    @EnvironmentObject var gastosVM: GastosViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(gasto.descripcion)
                    .font(.title3.bold())
                Text(gasto.monto, format: .currency(code: Locale.current.identifier))
                    .font(.caption)
                Text(gasto.fecha, formatter: dateFormatter)
                    .font(.caption)
            }
            Spacer()
            gastosVM.retornaImagen(datos: gasto.imagen)
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(gastosVM.colores[gastosVM.etiquetas.firstIndex(of: gasto.etiqueta) ?? 0], lineWidth: 2))
                .frame(width: 45, height: 45)
                .scaledToFit()
        }
    }
    
    init(gasto: Gasto) {
        self.gasto = gasto
    }
    
}



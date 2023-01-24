//
//  GastosFila.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

struct GastosFila: View {
    
    let gasto: Gasto
    @EnvironmentObject var gastosVM: GastosViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(gasto.descripcion)
                    .font(.subheadline.bold())
                Text(gasto.monto, format: .currency(code: Locale.current.identifier))
                    .font(.caption)
            }
            Spacer()
            Circle()
                .fill((gastosVM.colores[gastosVM.etiquetas.firstIndex(of: gasto.etiqueta) ?? 0]))
                .frame(width: 15, height: 15)
        }
    }
    
    init(gasto: Gasto) {
        self.gasto = gasto
    }
    
}



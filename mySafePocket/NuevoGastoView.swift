//
//  NuevoGastoView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

struct NuevoGastoView: View {
    
    @State private var descripcion: String = ""
    let tipoGasto = ["Gasto Fijo", "Inversion", "Compra"]
    @State private var gastoElegido = "Compra"
    @State private var monto = 0.0
    @Environment(\.dismiss) var dismiss
    @State private var mostrarAlerta = false
    @EnvironmentObject var gastosViewModel: GastosViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Descripcion del gasto", text: $descripcion)
                        TextField("Ingrese el monto", value: $monto, format: .currency(code: Locale.current.identifier))
                        Picker("Tipo de gasto", selection: $gastoElegido) {
                            ForEach(tipoGasto, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            if gastosViewModel.agregaGasto(descripcion: descripcion, monto: monto, etiqueta: gastoElegido) != nil
                            {
                                mostrarAlerta = true
                            } else {
                                dismiss()
                            }
                        }
                        .disabled(self.descripcion.isEmpty)
                        .alert("Ingrese un monto valido", isPresented: $mostrarAlerta)
                        {
                            Button("OK", role: .cancel) {}
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading)  {
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}


struct NuevoGastoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NuevoGastoView().environmentObject(GastosViewModel())
        }
    }
}

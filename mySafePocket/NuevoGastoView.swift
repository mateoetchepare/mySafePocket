//
//  NuevoGastoView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

struct NuevoGastoView: View {
    
    @State private var descripcion: String = ""
    @State private var gastoElegido = "Compra"
    @State private var monto = 0.0
    @State private var fecha: Date = Date.now
    @State private var calendarId = 0
    @Environment(\.dismiss) var dismiss
    @State private var mostrarAlerta = false
    @EnvironmentObject var gastosVM: GastosViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Descripcion del gasto", text: $descripcion)
                        TextField("Ingrese el monto", value: $monto, format: .currency(code: Locale.current.identifier))
                        Picker("Tipo de gasto", selection: $gastoElegido) {
                            ForEach(gastosVM.etiquetas, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        DatePicker("Fecha", selection: $fecha, in: ...Date.now, displayedComponents: .date)
                            .id(calendarId)
                            .onChange(of: fecha) { _ in
                                calendarId += 1
                            }
                            .onTapGesture {
                                calendarId += 1
                            }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            if gastosVM.agregaGasto(descripcion: descripcion, monto: monto, etiqueta: gastoElegido, fecha: fecha) != nil
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

//
//  ContentView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

struct GastosView: View {
    
    @EnvironmentObject var gastosVM: GastosViewModel
    @State private var mostrarSheet = false
    @State private var filtroTexto = ""
    
    var resultadoFiltrado: [Gasto] {
        if filtroTexto.isEmpty {
            return gastosVM.items
        } else {
            return gastosVM.items.filter { $0.descripcion.contains(filtroTexto)}
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack { // este HStack muestra todos los tipos de gastos
                    ForEach(gastosVM.etiquetas, id: \.self) { item in
                        Spacer()
                        Circle()
                            .fill(gastosVM.colores[gastosVM.etiquetas.firstIndex(of: item) ?? 0])
                            .frame(width: 15, height: 15)
                        Text(item)
                        Spacer()
                    }
                }
                Divider()
                    .frame(maxWidth: .infinity)
                    .overlay(Color.white.opacity(0.2))
                
                List {
                    ForEach(resultadoFiltrado) { gastos in
                        GastosFila(gasto: gastos)
                            .environmentObject(gastosVM)
                    }
                    .onDelete(perform: gastosVM.borraGastos)
                }
                .navigationTitle("Gastos")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            mostrarSheet.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                }
            }
            .searchable(text: $filtroTexto)
            .sheet(isPresented: $mostrarSheet) {
                NuevoGastoView()
                    .environmentObject(gastosVM)
            }
        }
    }
}

struct GastosView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GastosView()
        }
    }
}

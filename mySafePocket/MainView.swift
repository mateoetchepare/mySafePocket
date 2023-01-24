//
//  MainView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 19/01/2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var gastosVM = GastosViewModel()
    @StateObject var loginVM = LogInViewModel()
    
    var body: some View {
            TabView {
                GastosView()
                    .environmentObject(gastosVM)
                    .tabItem {
                        Label("Lista de gastos", systemImage: "dollarsign.circle")
                    }
                let (valores, nombres, colores) = gastosVM.calcularParametrosGrafico()
                PieChartView(values: valores, names: nombres, formatter: {value in String(format: "$%.2f", value)}, colors: colores)
                    .tabItem {
                        Label("Grafico de gastos", systemImage: "chart.bar.fill")
                    }
            }
            .sheet(isPresented: $loginVM.bloqueado) {
                LogInView()
                    .environmentObject(loginVM)
            }
        }
    }

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

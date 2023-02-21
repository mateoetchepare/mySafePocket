//
//  PadNumericoView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 23/01/2023.
//

import SwiftUI

struct formaPad: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if (colorScheme == .dark) {
            content
                .frame(width: 80, height: 78)
                .font(.largeTitle)
                .blur(radius: 0.2)
                .background(Color.white)
                .foregroundColor(Color.black)
                .clipShape(Circle())
        } else {
            content
                .frame(width: 80, height: 78)
                .font(.largeTitle)
                .background(Color.black)
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
                .clipShape(Circle())
        }
    }
}

extension View {
    func conFormaPad() -> some View {
        modifier(formaPad())
    }
}

struct PadNumericoView: View {
    
    @EnvironmentObject var loginVM: LogInViewModel
    @State private var desbloqueado = false
    let tamanoPin = 6
    @Environment(\.colorScheme) var colorScheme
    
    
    
    var color: Color {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    var colorBack: Color {
        if colorScheme == .dark {
            return Color.black
        } else {
            return Color.white
        }
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                ForEach(0..<tamanoPin) { indice in
                    Spacer()
                    /*
                    Circle()
                        .stroke(color, lineWidth: 2.5)
                        .frame(width: 25, height: 18)
                        .fill(loginVM.numerosIngresados.count >  ? color : colorBack)
                     */
                    Image(systemName: self.obtenerImagen(indice: indice))
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 20)
                    Spacer()
                    
                }
            }
            HStack {
                ForEach(1..<4) { numero in
                    Button("\(numero)") {
                        if loginVM.agregarNumero(numero: numero) {
                            loginVM.bloqueado = false
                        }
                    }
                    .conFormaPad()
                }
            }
            HStack {
                ForEach(4..<7) { numero in
                    Button("\(numero)") {
                        if loginVM.agregarNumero(numero: numero) {
                            loginVM.bloqueado = false
                        }
                    }
                    .conFormaPad()
                }
            }
            HStack {
                ForEach(7..<10) { numero in
                    Button("\(numero)") {
                        if loginVM.agregarNumero(numero: numero) {
                            loginVM.bloqueado = false
                        }
                    }
                    .conFormaPad()
                }
            }
            Button("0") {
                if loginVM.agregarNumero(numero: 0) {
                    loginVM.bloqueado = false
                }
            }
            .conFormaPad()
            HStack {
                Spacer()
                Button() {
                    loginVM.borrarNumero()
                } label: {
                    Label("", systemImage: "delete.left")
                        .font(.system(size: 30))
                        .foregroundColor(color)
                }
            }
        }
    }
    
    func obtenerImagen(indice: Int) -> String {
        if loginVM.numerosIngresados.count > indice {
            return "circle.fill"
        } else {
            return "circle"
        }
    }
    
}



struct PadNumericoView_Previews: PreviewProvider {
    static var previews: some View {
        PadNumericoView()
    }
}

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
    @Environment(\.colorScheme) var colorScheme
    
    var color: Color {
        if colorScheme == .dark {
            return Color.white.opacity(0.7)
        } else {
            return Color.black.opacity(0.6)
        }
    }
    
    var colorBack: Color {
        if colorScheme == .dark {
            return Color.black.opacity(0.7)
        } else {
            return Color.white.opacity(0.6)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ForEach(loginVM.numerosIngresados, id: \.self) { numero in
                        Circle()
                            .frame(width: 30, height: 20)
                            .foregroundColor(color)
                            .background(colorBack)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
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
    }
}


struct PadNumericoView_Previews: PreviewProvider {
    static var previews: some View {
        PadNumericoView()
    }
}

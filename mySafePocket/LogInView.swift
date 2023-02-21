//
//  LogInView.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 23/01/2023.
//
import SwiftUI

struct formaBoton: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if (colorScheme == .dark) {
            content
                .frame(width: 250, height: 80)
                .font(.title)
                .background(Color.white)
                .foregroundColor(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
                .shadow(color: Color.white, radius: 10)
                .padding()
        } else {
            content
                .frame(width: 250, height: 80)
                .font(.title)
                //.background(Color.blue)
                .background(Color.white)
                .foregroundColor(Color.black.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
                .shadow(radius: 10)
                .padding()
        }
    }
}

extension View {
    func botonForma() -> some View {
        modifier(formaBoton())
    }
}

struct LogInView: View {
    
    @EnvironmentObject var loginVM: LogInViewModel
    @State var mostrarPad = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("mySafePocket")
                    .font(.largeTitle)
                Spacer()
                Button() {
                    loginVM.autenticar()
                } label: {
                    Label("Usar Face ID", systemImage: "faceid")
                }
                .botonForma()
                Button() {
                    mostrarPad = true
                } label: {
                    Label("Usar PIN", systemImage: "keyboard.onehanded.right")
                }
                .botonForma()
                Spacer()
            }
            .navigationDestination(isPresented: $mostrarPad) {
                PadNumericoView()
            }
            .interactiveDismissDisabled(loginVM.bloqueado)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

//
//  LogInViewModel.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 23/01/2023.
//

import Foundation

@MainActor class LogInViewModel: ObservableObject {
    @Published var bloqueado = true
    var usuario: Usuario
    let directorio = FileManager.documentsDirectory.appendingPathComponent("passwordUsuario")
    @Published var numerosIngresados: [Int] = []
    
    init() { // esto es para recibir datos del directorio
        do {
            let data = try Data(contentsOf: directorio)
            usuario = try JSONDecoder().decode(Usuario.self, from: data)
        } catch {
            usuario = Usuario(password: 123456)
        }
    }
    
    func agregarNumero(numero: Int) -> Bool {
        if (numerosIngresados.count < 6) {
            numerosIngresados.append(numero)
            if (numerosIngresados.count == 6) {
                if (numerosIngresados.reduce(0, { $0 * 10 + $1 }) == usuario.getPassword()) { // paso de un int array a un int
                    return true
                } else {
                    numerosIngresados = []
                }
            }
        }
        return false
    }
    
    func borrarNumero() {
        numerosIngresados.removeLast()
    }
    
    func guardarPassword(password: Int) {
        usuario.cambiaPassword(password: password)
        do {
            let data = try JSONEncoder().encode(usuario)
            try data.write(to: directorio)
        } catch {
            fatalError("Se rompe al guardar los datos del usuario")
        }
    }
}

//
//  LogInViewModel.swift
//  mySafePocket
//
//  Created by Mateo Etchepare on 23/01/2023.
//

import Foundation
import LocalAuthentication

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

@MainActor class LogInViewModel: ObservableObject {
    @Published var bloqueado = true
    var usuario: Usuario
    let directorio = FileManager.documentsDirectory.appendingPathComponent("passwordUsuario")
    @Published var numerosIngresados: [Int] = []
    var llaveUltimoUso = "ultimoUso"

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
        if numerosIngresados.count > 0 {
            numerosIngresados.removeLast()
        }
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
    
    func guardaUltimoUso() {
        let defaults = UserDefaults.standard
        defaults.set(Date.now, forKey: llaveUltimoUso)
    }
    
    func validarIdentidad() {
        if let ultimoUso = UserDefaults.standard.object(forKey: llaveUltimoUso) as? Date {
            if Date.now - ultimoUso > 15 { // uso la extension de arriba. Si pasan X segundos que revalide identidad
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.bloqueado = true
                    self.numerosIngresados = []
                    self.guardaUltimoUso() // esto es por si se vuelve a invocar luego de 15 segundos de espera
                    // en la pantalla de faceID, y finalmente desbloqueas, no va a dejar usar la app ya q el ultimo uso
                    // va a ser viejo entonces se va a constantemente bloquear. (esto anda raro, porque esta hecho
                    // con un onChange en la mainView, no se tendria que invocar de vuelta este metodo si nunca te vas de la app
                }
            }
        }
    }
    
    func autenticar () {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let motivo = "Hay que validar su identidad"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: motivo) { success, authError in
                if success {
                    Task {
                        await MainActor.run {
                            self.bloqueado = false
                        }
                    }
                } else {
                    Task {
                        await MainActor.run {
                            self.bloqueado = true
                        }
                    }
                }
            }
        }
    }
}

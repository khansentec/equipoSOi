//
//  VistaEstadoSalud.swift
//  portalPaciente
//
//  Created by Katie Hansen on 9/17/22.
//

import SwiftUI

struct VistaEstadoSalud: View {
    
    @State var descanso : String
    @State var sentimiento : String
    @State var comentarios : String
    @State private var speed = 10.0
    
    var body: some View {
        
        NavigationView {
            
            VStack (alignment: .leading) {
                VStack (alignment: .leading){
                    Text("Sentimiento del día: ")
                    Slider(
                        value: $speed,
                        in: 0...10
                    )
                    Text("\(Int(speed))")
                }
                
                HStack {
                    Text("Horas de descanso: ")
                    TextField("", value: $descanso, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .scenePadding()
                HStack {
                    Text("Sentimiento del día: ")
                    TextField("", text: $sentimiento)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .scenePadding()
                HStack {
                    Text("Síntomas nuevas: ")
                    TextField("", text: $sentimiento)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .scenePadding()
                
                HStack {
                    Text("Otros comentarios: ")
                    TextField("", text: $comentarios)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .scenePadding()
                
                Spacer()
            }
            .scenePadding()
            .navigationTitle("Estado de salud")
            
        }
    }
}

struct VistaEstadoSalud_Previews: PreviewProvider {
    static var previews: some View {
        VistaEstadoSalud(descanso: "", sentimiento: "", comentarios: "")
    }
}
//
//  ContentView.swift
//  ProyectoSOi
//
//  Created by alumno on 19/09/22.
//

import SwiftUI

struct CapturaPresionView: View {
    @State var presionSupStr1 = ""
    @State var presionInfStr1 = ""
    @State var pulsoStr1 = ""
    @State var presionSupStr2 = ""
    @State var presionInfStr2 = ""
    @State var pulsoStr2 = ""
    @State var presionSupStr3 = ""
    @State var presionInfStr3 = ""
    @State var pulsoStr3 = ""
    
    @State var alertaCapturaInvalida = false
    
    @State var fecha = Date.now
    
    @State var estado = true
    @State var idPaciente = "12345"
    
    @State var timerShow = false
    @State var tiempoRestante = 0
    
    @State var validacion1 = false
    @State var validacion2 = false
    @State var validacion3 = false
    @State var mensaje1 = ""
    @State var mensaje2 = ""
    @State var mensaje3 = ""
    
    var med = Medicion(idPaciente: "", fecha: Date.now)
    
    var device = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var width
    
    var body: some View {
        
        ZStack{
            ScrollView{
                VStack() {
                    VStack(alignment: .leading, spacing: 6){
                        HStack{
                            Text("¿Se encuentra relajado?")
                                .padding(.bottom,5)
                            Picker(selection: $estado, label: Text("Picker")) {
                                Text("Sí").tag(true)
                                Text("No").tag(false)
                            }.frame(width : 40, height: 10)
                                .accentColor(.blue)
                                .padding(.top,-5)
                        }
                        
                        Text("Si selecciono 'No', no debe hacerse la captura en este momento")
                            .padding(.bottom,20)
                            .font(.system(size : 10))
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 30)
                        HStack {
                            Text("Captura 1")
                                
                            TextField("Superior", text: $presionSupStr1)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize()
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                            Text("/")
                            TextField("Inferior", text: $presionInfStr1)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                            Button(action:{
                                tiempoRestante =  300
                                timerShow.toggle()
                            }) {
                                Image(systemName: "clock")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }.sheet(isPresented: $timerShow, content: {
                                TemporizadorView(timerTime: $tiempoRestante)
                            })
                            
                        }
                        
                        HStack{
                            Text("Pulso")
                            TextField("Pulso", text: $pulsoStr1)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize()
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                            
                        }
                        .padding(.top,15)
                        .padding(.bottom,20)
                        
                        HStack {
                            Text("Captura 2")
                            TextField("Superior", text: $presionSupStr2)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize() .keyboardType(.numberPad)
                                .disabled(!estado)
                            Text("/")
                            TextField("Inferior", text: $presionInfStr2)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                            Button(action:{
                                tiempoRestante =  120
                                timerShow.toggle()
                            }) {
                                Image(systemName: "clock")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }.sheet(isPresented: $timerShow, content: {
                                TemporizadorView(timerTime: $tiempoRestante)
                            })
                        }
                        HStack{
                            Text("Pulso")
                            TextField("Pulso", text: $pulsoStr2)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize()
                                .keyboardType(.numberPad).disabled(!estado)
                                .disabled(!estado)
                        }
                        .padding(.top,15)
                        .padding(.bottom,20)
                        
                        HStack {
                            Text("Captura 3")
                            TextField("Superior", text: $presionSupStr3)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize()
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                            Text("/")
                            TextField("Inferior", text: $presionInfStr3)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                            
                            Button(action:{
                                tiempoRestante =  120
                                timerShow.toggle()
                            }) {
                                Image(systemName: "clock")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }.sheet(isPresented: $timerShow, content: {
                                TemporizadorView(timerTime: $tiempoRestante)
                            })
                        }
                        HStack{
                            Text("Pulso")
                            TextField("Pulso", text: $pulsoStr3)
                                .font(.system(size: device == .pad ? 16 : 12))
                                .frame(width:device == .pad ? 80 : 65)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fixedSize()
                                .keyboardType(.numberPad)
                                .disabled(!estado)
                        }
                        .padding(.top,15)
                        .padding(.bottom,20)
                    }
                    .padding(.leading,15)
                    
                    Text("Ingresa la fecha y hora:")
                        .padding(.bottom,20)
                    
                    DatePicker("", selection: $fecha)
                        .foregroundColor(.blue)
                        .padding(.bottom,20)
                        .padding(.trailing,70)
                        .padding(.leading,0)
                    
                    Button("Enviar") {
                        med.cambiarIDPaciente(nuevoIdPaciente: idPaciente)
                        med.cambiarFecha(nuevaFecha: fecha)
                        let validacionCaptura1 = med.validarCaptura(presionSupStr: presionSupStr1, presionInfStr: presionInfStr1, pulsoStr: pulsoStr1)
                        
                        validacion1 = validacionCaptura1.0
                        mensaje1 = validacionCaptura1.1
                        
                        let validacionCaptura2 = med.validarCaptura(presionSupStr: presionSupStr2, presionInfStr: presionInfStr2, pulsoStr: pulsoStr2)
                        
                        validacion2 = validacionCaptura2.0
                        mensaje2 = validacionCaptura2.1
                        
                        let validacionCaptura3 = med.validarCaptura(presionSupStr: presionSupStr3, presionInfStr: presionInfStr3, pulsoStr: pulsoStr3)
                        
                        validacion3 = validacionCaptura3.0
                        mensaje3 = validacionCaptura3.1
                        
                        if (!validacion1  || !validacion2 || !validacion3) || mensaje1 == "Sin datos" {
                            alertaCapturaInvalida = true
                        }else{
                            print("info enviada")
                            
                            if validacion1{
                                let presionSup1 = Int(presionSupStr1)!
                                let presionInf1 = Int(presionInfStr1)!
                                
                                var pulso1 = -1
                                if let pulsotemp = Int(pulsoStr1){
                                    pulso1 = pulsotemp
                                }
                                
                                let cap1 = Captura(presionSup: presionSup1, presionInf: presionInf1, pulso: pulso1)
                                med.agregarCaptura(nuevaCaptura: cap1)
                                
                            }
                            if validacion2{
                                let presionSup2 = Int(presionSupStr2)!
                                let presionInf2 = Int(presionInfStr2)!
                                
                                var pulso2 = -1
                                if let pulsotemp = Int(pulsoStr2){
                                    pulso2 = pulsotemp
                                }
                                
                                let cap2 = Captura(presionSup: presionSup2, presionInf: presionInf2, pulso: pulso2)
                                
                                med.agregarCaptura(nuevaCaptura: cap2)
                                
                            }
                            if validacion3{
                                let presionSup3 = Int(presionSupStr3)!
                                let presionInf3 = Int(presionInfStr3)!
                                
                                var pulso3 = -1
                                if let pulsotemp = Int(pulsoStr3){
                                    pulso3 = pulsotemp
                                }
                                
                                let cap3 = Captura(presionSup: presionSup3, presionInf: presionInf3, pulso: pulso3)
                                med.agregarCaptura(nuevaCaptura: cap3)
                            }
                             
                        }
                    }.alert("Error", isPresented: $alertaCapturaInvalida){
                        
                        Button("OK"){
                            //si se oprime quitar el ok
                        }
                    } message: {
                        if !validacion1 && mensaje1 != "Sin datos"{
                            Text(mensaje1)
                        }else if !validacion2 && mensaje2 != "Sin datos" {
                            Text(mensaje2)
                        } else if !validacion3 && mensaje3 != "Sin datos" {
                            Text(mensaje3)
                        }else {
                            Text("Debe ingresar datos en Captura 1")
                        }
                    }.background(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.red, lineWidth: 1)
                        .frame(minWidth: 100,minHeight: 40))
                }
                
            }
            
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CapturaPresionView()
    }
}
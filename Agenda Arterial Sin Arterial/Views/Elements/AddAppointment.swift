//
//  AddAppointment.swift
//  Agenda Arterial V2.0
//
//  Created by Gabriel Crisostomo on 12/10/22.
//

import SwiftUI
import Firebase

struct AddAppointment: View {
    @Binding var medics : [Medic]
    var device = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var width
    
    @State var comments = ""
    @State var date = Date.now
    
    @State var alertMessage = "Error"
    @State var alertTitle = ""
    
    @Binding var addAppointment : Bool
    @State var edit = false
    @State var error = false
    @State var selectedMedic = "Sin seleccionar"
    
    @StateObject var login = FirebaseViewController()
    
    var body: some View {
        VStack (spacing : 10){
            Text("Agregar Consulta").font(.title)
            HStack{
                Text("Médico: ")
                Picker("Selecione un médico", selection: $selectedMedic) {
                    if medics.isEmpty{
                        Text("Por favor de vincular un médico").tag("Sin seleccionar")
                    }else{
                        Text("Selecione un médico").tag("Sin seleccionar")
                        ForEach(medics, id: \.self) { medic in
                            Text("\(medic.name) \(medic.patName) \(medic.matName)").tag(medic.id)
                        }
                    }
                }
            }
            VStack{
                Text("Fecha de la consulta: ").padding(.leading, 20)
                DatePicker("", selection: $date)
                    .padding(.trailing,70)
                
            }.padding(.all,20)
            Text("Comentarios")
            HStack{
                TextEditor(text: $comments).frame(width: 270, height: 200, alignment: .leading)
                
            }.overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1))
            
            
            HStack {
                Button("Guardar") {
                    let id = UUID().uuidString
                    let appoinment = Appointment(id: id, date: date, idMedic: selectedMedic, comments: comments)
                    let upload = appoinment.uploadAppointment()
                    if upload.0{
                        self.addAppointment.toggle()
                    }else{
                        error = true
                        alertTitle = upload.1
                        alertMessage = upload.2
                    }
                    
                    
                }.alert(alertTitle, isPresented: $error){
                    
                    Button("OK"){
                        if alertMessage == "Datos válidos" {
                            self.addAppointment.toggle()
                        }
                        //si se oprime quitar el ok
                    }
                } message: {
                    Text(alertMessage)
                }
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color("ButtonColor"))
                .frame(minWidth: 100,minHeight: 40))
                
            }
            .padding(.top, 20)
        }
        .onTapGesture{
            hideKeyboard()
        }
    }
}

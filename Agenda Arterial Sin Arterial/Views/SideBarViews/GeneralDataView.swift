//
//  GeneralDataView.swift
//  Agenda Arterial V1
//
//  Created by Gabriel Crisostomo on 22/09/22.
//

import SwiftUI

struct GeneralDataView: View {
    
    @State private var index = "Datos Generales"
    @State private var menu = false
    @State private var widthMenu = UIScreen.main.bounds.width
    @State private var heightMenu = UIScreen.main.bounds.height
    @StateObject var login = FirebaseViewController()
    @EnvironmentObject var loginShow : FirebaseViewController
    
    @State private var imageData : Data = .init(capacity: 0)
    @State private var showMenu = false
    @State private var imagePicker = false
    @State private var source : UIImagePickerController.SourceType = .camera
    
    @StateObject var save = FirebaseViewController()
    
    @State private var progress = false
    
    @State var id = ""
    @State var name = ""
    @State var patName = ""
    @State var matName = ""
    @State var photo = ""
    @State var sex = ""
    @State var birthDate = Date()
    @State var phone = ""
    @State var height = 0.0
    @State var weight = 0.0
    @State var cirAbdominal = 0.0
    @State var medDisease = ""
    @State var bloodType = ""
    @State var nextAppointment = Date()
    @State var currPaciente = Pacient(id: "", name: nil, patName: nil, matName: nil, photo: nil, sex: nil, pacientStatus: nil, birthDate: Date(), phone: nil, height: nil, weight: nil, cirAbdominal: nil, medDisease: nil, bloodType: nil, nextAppointment: nil, lastAppointment: nil, vinculationCode: nil, associatedMedic: nil)
    
    @State private var padecimientos: String = "Padecimientos aquí"
    
    @State var dataSubmitted = false
    @State var dataIsValid = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    func validateData() {
        let result = currPaciente.changeInfoPatient(newName: name, newPatName: patName, newMatName: matName, newPhoto: photo, newSex: sex, newBirthDate: birthDate, newPhone: phone, newHeight: height, newWeight: weight, newCirAbdominal: cirAbdominal, newMedDisease: medDisease, newBloodType: bloodType, newNextAppointment: nextAppointment)
        
        dataIsValid = result.0
        if dataIsValid {
            alertTitle = "¡Éxito!"
            alertMessage = "Datos guardados con éxito."
        }
        else {
            alertTitle = "Error"
            alertMessage = result.1
        }
        
        dataSubmitted = true
        
    }
    
    var body: some View {
        
        ZStack(alignment: .leading){
            
            VStack {
                NavBarHome(menu:$menu).onTapGesture {
                    withAnimation{
                        menu = false
                    }
                }
                
                ScrollView{
                    
                    VStack {
                        
                        if imageData.count != 0{
                            Image(uiImage: UIImage(data: imageData)!).resizable().frame(width: 125, height: 125).cornerRadius(15).clipShape(Circle())
                        } else{
                            Image(systemName: "person.circle").resizable().aspectRatio(contentMode: .fit).frame(width: 125, height: 125).clipShape(Circle())
                        }
                        
                        Spacer(minLength: 15)
                        
                        Button(action: {showMenu.toggle()}){
                            Text("Tomar foto de pérfil")
                                .underline()
                        }
                        .confirmationDialog("Select an option: ", isPresented: $showMenu, actions: {
                            Button(action: {
                                source = .camera
                                imagePicker.toggle()
                            }){
                                Text("Camera")
                            }
                            Button(action: {
                                source = .photoLibrary
                                imagePicker.toggle()
                            }){
                                Text("Library")
                            }
                            
                        })
                        .foregroundColor(Color("ButtonColor"))
                        
                    }
                    .padding(.bottom, 20)
                    
                    if progress{
                        Text("Please Wait One Moment...").foregroundColor(.black)
                        ProgressView()
                    }
                    
                    
                    VStack (spacing: 10) {
                        HStack{
                            Text("Altura")
                            TextField("Altura",value: $height,formatter: NumberFormatter()).keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack{
                            Text("Peso")
                            TextField("Peso",value: $weight,formatter: NumberFormatter()).keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack{
                            Text("Circuferencia Abdominal")
                            TextField("Circuferencia Abdominal",value: $cirAbdominal,formatter: NumberFormatter()).keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack{
                            Text("Tipo de Sangre")
                            TextField("Tipo de Sangre", text: $bloodType).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        }
                        
                        Text("Padecimientos")
                        HStack{
                            TextEditor(text: $padecimientos).frame(width: widthMenu == 375 ? 270 : 270, height: 300, alignment: .leading)
                            
                        }.overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1))
                        
                        Button("Enviar"){
                            validateData()
                        }
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color("ButtonColor"))
                            .frame(minWidth: 100,minHeight: 40))
                        
                        .alert(alertTitle, isPresented: $dataSubmitted){
                            Button("OK"){
                                //si se oprime quitar el ok
                            }
                        } message: {
                            Text(alertMessage)
                        }
                    }
                    .padding(.init(top: 0, leading: 20, bottom: 50, trailing: 20))
                    
                }
                
            }
            .onTapGesture {
                menu = false
                hideKeyboard()
            }
            
            if menu{
                NavBarMenu(index: "Datos Generales", menu: false)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}
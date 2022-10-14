//
//  FirebaseViewController.swift
//  Agenda Arterial V2.0
//
//  Created by Gabriel Crisostomo on 30/09/22.
//

import Foundation
import Firebase
import FirebaseStorage



class FirebaseViewController: ObservableObject{
    
    @Published var show = "Login"
    @Published var showApp = "Home"
    @Published var autfail = false
    @Published var data : Pacient!
    @Published var meds = [Medicament]()
    @Published var medUpdate : Medicament!
    @Published var reminds = [Remind]()
    @Published var remindUpdate : Remind!
    @Published var medics = [Medic]()
    
    var meditionsRem = true
    var healthReportsRem = true
    var weekReportsRem = true
    var appointmentsRem = true
    
    func sendMed(item: Medicament){
        medUpdate = item
    }
    
    func sendRemind(item: Remind){
        remindUpdate = item
    }
    
    func saveData(collectionName: String, id: String, info: [String: Any], completion: @escaping(_ done: Bool)->Void){
        
        let db = Firestore.firestore()
        
        db.collection(collectionName).document(id).setData(info){error in
            if let error = error?.localizedDescription{
                print("Error al guardar en firestore ", error)
                completion(false)
            }else{
                print("Sucessfully save info")
                completion(true)
            }
        }
    }
    
    func deleteData(collectionName: String, id: String, completion: @escaping(_ done: Bool)->Void){
        let db = Firestore.firestore()
        db.collection(collectionName).document(id).delete
        {error in
            if let error = error?.localizedDescription{
                print("Error al borrar en firestore ", error)
                completion(false)
            }else{
                print("Sucessfully delete info")
                completion(true)
            }
        }
    }
    
    func login( email: String, pass: String, completion: @escaping( _ done: Bool) -> Void)  {
        Auth.auth().signIn(withEmail: email, password: pass){
            (user, error) in
            if user != nil{
                completion(true)
            }else{
                self.autfail = true
                if var error = error?.localizedDescription{
                    
                    print("Error in firebase: ",error)
                    completion(false)
                }else{
                    print("Error in the app")
                }
                
            }
        }
    }
    
    func createUser( email: String, pass: String, name: String, ptName : String, mtName : String, bDate: Date, phone: String, sex: String, completion: @escaping( _ done: Bool, _ errorM: String) -> Void)  {
        let db = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: email, password: pass){
            (user, error) in
            if user != nil{
                guard let idUser = Auth.auth().currentUser?.uid else{
                    return
                }
                let pacient = Pacient(id: idUser, name: name, patName: ptName, matName: mtName, photo: "", sex: sex, pacientStatus: "", birthDate: bDate, phone: phone, height: 0, weight: 0, cirAbdominal: 0, medDisease: "", bloodType: "", vinculationCode: "", associatedMedic: [])
                let info : [String: Any] = ["idUsuario":idUser,"apellidoMaterno":mtName, "apellidoPaterno": ptName, "email":email, "fechaNacimiento": bDate, "nombre":name, "sexo":sex, "telefono": phone, "altura":0, "circunferenciaAbdominal":0, "foto": "", "peso": 0, "tipoSangre": "", "padecimientosMedicos": "", "codigoVinculacion":"","estadoPaciente":"", "listaMedicosVinculados":[]]
                self.data = pacient
                let id = UUID().uuidString
                
                db.collection("pacientes").document(id).setData(info){error in
                    
                    if let errorM = error?.localizedDescription{
                        
                        print("Error al guardar en firestore \(type(of: errorM)) as ", errorM)
                        completion(false,errorM)
                    }else{
                        
                        print("Sucessfully save info")
                        completion(true, "ok")
                    }
                }
            }else{
                self.autfail = true
                if let error = error?.localizedDescription{
                    print("Error on register in firebase: ",error)
                    completion(false, error)
                }else{
                    print("Error in the app")
                }
                
            }
        }
    }
    
    //Database
    
    //Save
    //
    func saveBP(state: String, dateC: Date, pressureS: Int, pressureD: Int, pulse: Int, completion: @escaping(_ done: Bool)->Void){
        
        //        let storage = Storage.storage().reference()
        //Save Text
        let db = Firestore.firestore()
        let id = UUID().uuidString
        
        guard let idUser = Auth.auth().currentUser?.uid else{
            return
        }
        
        let info : [String: Any] = ["idUsuario":idUser, "estado":state,  "fecha": dateC, "presionInfPromedio":pressureS, "presionSupPromedio":pressureD, "pulsoPromedio":pulse ]
        
        db.collection("mediciones").document(id).setData(info){error in
            if let error = error?.localizedDescription{
                print("Error al guardar en firestore ", error)
                completion(false)
            }else{
                print("Sucessfully save info")
                completion(true)
            }
        }
        //End Saving Text
    }
    
    func saveGD(name: String, lastNP: String, lastNM: String,  phone: String, sex: String, height: Float, abdominalCir: Float, diseases: String, weight: Float, bType: String, photo: Data, urlPhoto: String?, editingPhoto: Bool, completion: @escaping(_ done: Bool)->Void){
        let db = Firestore.firestore()
        guard let idUser = Auth.auth().currentUser?.uid else{
            return
        }
        var docId = ""
        print("foto before:")
        db.collection("pacientes").whereField("idUsuario", isEqualTo: idUser)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        docId = document.documentID
                        let value = document.data()
                        let fotoF = value["foto"] as? String ?? "no profile pic"
                        print("fotoF: \(fotoF)")
                        if fotoF == ""{
                            print("first")
                            let storage = Storage.storage().reference()
                            let profilepic = UUID()
                            let directory = storage.child("profilepics/\(profilepic)")
                            let metaData = StorageMetadata()
                            metaData.contentType = "image/png"
                            
                            directory.putData(photo, metadata: metaData){data, error in
                                if error == nil{
                                    var dir = "a"
                                    let db = Firestore.firestore()
                                    directory.downloadURL{
                                        url, error in
                                        if let error = error {
                                            // Handle any errors
                                            print(error)
                                        } else {
                                            // Get the download URL for each item storage location
                                            dir = String(describing: url!)
                                            print("url : \(dir)")
                                            let info : [String: Any] = ["apellidoMaterno":lastNP, "apellidoPaterno": lastNM, "nombre":name, "sexo":sex, "telefono": phone,"altura":height,"circunferenciaAbdominal":abdominalCir,"foto": dir, "peso":weight, "tipoSangre": bType, "padecimientosMedicos":diseases]
                                            
                                            db.collection("pacientes").document(docId).updateData(info){error in
                                                if let error = error?.localizedDescription{
                                                    print("Error al guardar en firestore ", error)
                                                    completion(false)
                                                }else{
                                                    print("Sucessfully save info")
                                                    completion(true)
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    //End Saving Text
                                }else{
                                    if let error = error?.localizedDescription{
                                        print("Failes to upload image in storge", error)
                                    }else{
                                        print("app error")
                                    }
                                }
                            }
                        }else{
                            print("foto from class: \(self.data.photo)")
                            let value = document.data()
                            let image = value["foto"] as? String ?? "no profile pic"
                            let storageImage = Storage.storage().reference(forURL: self.data.photo)
                            storageImage.getData(maxSize: 1*1024*1024){
                                (data, error) in
                                if let error = error?.localizedDescription {
                                   
                                        print("foto here in third")
                                        let deleteImage = Storage.storage().reference(forURL: image)
                                        deleteImage.delete(completion: nil)
                                        
                                        let storage = Storage.storage().reference()
                                        let profilepic = UUID()
                                        let directory = storage.child("profilepics/\(profilepic)")
                                        let metaData = StorageMetadata()
                                        metaData.contentType = "image/png"
                                        directory.putData(photo, metadata: metaData){data, error in
                                            if error == nil{
                                                print("saved image")
                                                //Save Text
                                                var dir = "a"
                                                let db = Firestore.firestore()
                                                directory.downloadURL{
                                                    url, error in
                                                    if let error = error {
                                                        // Handle any errors
                                                        print(error)
                                                    } else {
                                                        // Get the download URL for each item storage location
                                                        dir = String(describing: url!)
                                                        print("url : \(dir)")
                                                        let info : [String: Any] = ["apellidoMaterno":lastNM, "apellidoPaterno": lastNP, "nombre":name, "sexo":sex, "telefono": phone,"altura":height,"circunferenciaAbdominal":abdominalCir,"foto": dir, "peso":weight, "tipoSangre": bType, "padecimientosMedicos":diseases]
                                                        
                                                        db.collection("pacientes").document(docId).updateData(info){error in
                                                            if let error = error?.localizedDescription{
                                                                print("Error al guardar en firestore ", error)
                                                                completion(false)
                                                            }else{
                                                                print("Sucessfully save info")
                                                                self.getPacient(){
                                                                    (done)in
                                                                    if done{
                                                                        print("info succesfully update")
                                                                        completion(true)
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                                
                                                
                                                //End Saving Text
                                            }else{
                                                if let error = error?.localizedDescription{
                                                    print("Failes to upload image in storge", error)
                                                }else{
                                                    print("app error")
                                                }
                                            }
                                        }
                                    
                                }else{
                                    if !editingPhoto{
                                        print("second")
                                        let info : [String: Any] = ["apellidoMaterno":lastNP, "apellidoPaterno": lastNM, "nombre":name, "sexo":sex, "telefono": phone,"altura":height,"circunferenciaAbdominal":abdominalCir, "peso":weight, "tipoSangre": bType, "padecimientosMedicos":diseases]
                                        
                                        db.collection("pacientes").document(docId).updateData(info){error in
                                            if let error = error?.localizedDescription{
                                                print("Error al guardar en firestore ", error)
                                                completion(false)
                                            }else{
                                                print("Sucessfully save info")
                                                self.getPacient(){
                                                    (done)in
                                                    if done{
                                                        print("update info succesfully")
                                                        completion(true)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }else{
                                        
                                        print("foto here in third")
                                        let deleteImage = Storage.storage().reference(forURL: image)
                                        deleteImage.delete(completion: nil)
                                        
                                        let storage = Storage.storage().reference()
                                        let profilepic = UUID()
                                        let directory = storage.child("profilepics/\(profilepic)")
                                        let metaData = StorageMetadata()
                                        metaData.contentType = "image/png"
                                        directory.putData(photo, metadata: metaData){data, error in
                                            if error == nil{
                                                print("saved image")
                                                //Save Text
                                                var dir = "a"
                                                let db = Firestore.firestore()
                                                directory.downloadURL{
                                                    url, error in
                                                    if let error = error {
                                                        // Handle any errors
                                                        print(error)
                                                    } else {
                                                        // Get the download URL for each item storage location
                                                        dir = String(describing: url!)
                                                        print("url : \(dir)")
                                                        let info : [String: Any] = ["apellidoMaterno":lastNM, "apellidoPaterno": lastNP, "nombre":name, "sexo":sex, "telefono": phone,"altura":height,"circunferenciaAbdominal":abdominalCir,"foto": dir, "peso":weight, "tipoSangre": bType, "padecimientosMedicos":diseases]
                                                        
                                                        db.collection("pacientes").document(docId).updateData(info){error in
                                                            if let error = error?.localizedDescription{
                                                                print("Error al guardar en firestore ", error)
                                                                completion(false)
                                                            }else{
                                                                print("Sucessfully save info")
                                                                self.getPacient(){
                                                                    (done)in
                                                                    if done{
                                                                        print("info succesfully update")
                                                                        completion(true)
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                                
                                                
                                                //End Saving Text
                                            }else{
                                                if let error = error?.localizedDescription{
                                                    print("Failes to upload image in storge", error)
                                                }else{
                                                    print("app error")
                                                }
                                            }
                                        }
                                    
                                }
                                }
                            }
                           
                        }
                    }
                }
            }
        
        
        
    }
    
    func getPacient(completion: @escaping(_ done: Bool)->Void){
        let idUser = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection("pacientes").whereField("idUsuario", isEqualTo: idUser!)
            .getDocuments() {
                
                (QuerySnapshot, error) in
                if let error = error?.localizedDescription{
                    print("error to show data ", error)
                }else{
                    for document in QuerySnapshot!.documents{
                        
                        let value = document.data()
                        let id = value["uid"] as? String ?? "no user"
                        let name = value["nombre"] as? String ?? "no name"
                        let patName = value["apellidoPaterno"] as? String ?? "no lastname"
                        let matName = value["apellidoMaterno"] as? String ?? "no 2° lastname"
                        let phone = value["telefono"] as? String ?? "no phone number"
                        let foto = value["foto"] as? String ?? "no profile pic"
                        let sex = value["sexo"] as? String ?? "no sex"
                        let pacientStatus = value["estadoPaciente"] as? String ?? "no state"
                        let birthDate = (value["fechaNacimiento"] as? Timestamp)?.dateValue()  ?? Date()
                        let height = value["altura"] as? Float ?? 0
                        let weight  = value["peso"] as? Float ?? 0
                        let cirAbdominal = value["circunferenciaAbdominal"] as? Float ?? 0
                        let diseases = value["padecimientosMedicos"] as? String ?? "no ailings"
                        let bloodType = value["tipoSangre"] as? String ?? "no blood type"
                        let vinculationCode = value["codigoVinculacion"] as? String ?? "no code"
                        let associatedMedic = value["listaMedicosVinculados"] as? [String] ?? []
                        DispatchQueue.main.async {
                            let register = Pacient(id: id, name: name, patName: patName, matName: matName, photo: foto, sex: sex, pacientStatus: pacientStatus, birthDate: birthDate, phone: phone, height: height, weight: weight, cirAbdominal: cirAbdominal, medDisease: diseases, bloodType: bloodType, vinculationCode: vinculationCode, associatedMedic: associatedMedic)
                            self.data = register
                            completion(true)
                        }
                        
                    }
                }
            }
        
    }
    
    func generateLinkCode(completion: @escaping(_ done: Bool)->Void) -> [Int]{
        
        var linkCode = [Int]()
        var linkCodeS = ""
        for _ in 1...4{
            let randomInt = Int.random(in: 0..<9)
            linkCodeS.append(String(randomInt))
            linkCode.append(randomInt)
        }
        let db = Firestore.firestore()
        guard let email = Auth.auth().currentUser?.email else{
            return [0,0,0,0]
        }
        db.collection("pacientes").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let linkCodeF: [String: Any] = ["codigoVinculacion":linkCodeS]
                        db.collection("pacientes").document(document.documentID).updateData(linkCodeF){error in
                            if let error = error?.localizedDescription{
                                print("Error al guardar en firestore ", error)
                                completion(false)
                            }else{
                                print("Sucessfully save info")
                                completion(true)
                            }
                        }
                    }
                }
            }
        
        return linkCode
    }
    
    func getMedics(){
        
        let db = Firestore.firestore()
        let idUser = Auth.auth().currentUser?.uid
        
        db.collection("pacientes").whereField("idUsuario", isEqualTo: idUser!)
            .getDocuments() {
                
                (QuerySnapshot, error) in
                if let error = error?.localizedDescription{
                    print("error to show data ", error)
                }else{
                    for document in QuerySnapshot!.documents{
                        
                        let value = document.data()
                        let associatedMedic = value["listaMedicosVinculados"] as? [String] ?? []
                        
                        for medic in associatedMedic{
                            db.collection("medicos").whereField("uid", isEqualTo: medic)
                                .getDocuments() {
                                    (QuerySnapshot, error) in
                                    if let error = error?.localizedDescription{
                                        print("error to show data ", error)
                                    }else{
                                        self.medics.removeAll()
                                        for document in QuerySnapshot!.documents{
                                            let value = document.data()
                                            let id = value["uid"] as? String ?? "no id"
                                            let name = value["nombres"] as? String ?? "no name"
                                            let matName = value["apellidoMaterno"] as? String ?? "no matName"
                                            let patName = value["apellidoPaterno"] as? String ?? "no patName"
                                            let proflicense = value["cedulaProfesional"] as? String ?? "no proflicense"
                                            let email = value["email"] as? String ?? "no email"
                                            let foto = value["foto"] as? String ?? "no foto"
                                            
                                            DispatchQueue.main.async {
                                                let register =  Medic(id: id, name: name, patName: patName, matName: matName, email: email, foto: foto, proflicense: proflicense)
                                                self.medics.append(register)
                                            }
                                            
                                        }
                                    }
                                }
                        }
                        
                    }
                }
            }
        
    }
    
  
    
    
}
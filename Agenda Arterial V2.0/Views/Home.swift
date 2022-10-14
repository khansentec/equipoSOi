//
//  Home.swift
//  Agenda Arterial V2.0
//
//  Created by Gabriel Crisostomo on 30/09/22.
//

import Firebase
import SwiftUI

struct Home: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    @State private var index = "Menu Principal"
    @State private var menu = false
    @State private var widthMenu = UIScreen.main.bounds.width
    @State var showApp = "Home"
    
    @StateObject var login = FirebaseViewController()
    @EnvironmentObject var loginShow : FirebaseViewController
    
    //    let ejemploRecordatorios = [
    //        Remind(date: "28/2/19", events: ["Proxima Cita"]),
    //        Remind(date: "29/2/19", events: ["Proxima medicion","Proxima toma de presion"])
    //    ]
    
    
    var body: some View {
        ZStack(alignment: .leading){
            VStack{
                NavBarHome(menu: $menu, index: $index)
                
                ZStack{
                    switch loginShow.showApp{
                    case "Home":
                        AppsView().onAppear(){
                            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                                login.getMedicaments()
                                
                            }
                        }
                    case "CapturesView":
                        CapturesView().edgesIgnoringSafeArea(.all)
                    case "MedicamentsView":
                        MedicamentsView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).onAppear(){
                            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                                login.getMedicaments()
                            }
                        }
                    case "WeekReportView":
                        WeekReportView().edgesIgnoringSafeArea(.all)
                    case "HealthStateView":
                        HealthStateView().edgesIgnoringSafeArea(.all)
                    case "LikYourMedicView":
                        LinkYourMedicView(listMedics: $login.medics).edgesIgnoringSafeArea(.all).onAppear(){
                            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                                login.getMedics()
                            }
                        }
                    case "RemindersView":
                        RemindersView(remindersList: [], medics: $login.medics).edgesIgnoringSafeArea(.all).onAppear{
                            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                                login.getMedics()
                            }
                        }
                    default:
                        AppsView()
                    }
                    
                    
                }
                
            }.background(.white).onTapGesture {
                withAnimation{
                    menu = false
                }
            }
            if menu{
                HStack{
                    VStack{
                        HStack{
                            Button(action: {
                                withAnimation{
                                    menu.toggle()
                                }
                            }){
                                Image(systemName: "arrow.left")
                                    .font(.system(size:  widthMenu == 375 ? 18 : 19, weight: .bold)).foregroundColor(.blue)
                                    .foregroundColor(.white)
                                Text(loginShow.showApp != "Home" ? "" : "Menu Principal").foregroundColor(.blue).font(.system(size:  widthMenu == 375 ? 12 : 13, weight: .bold))
                            }
                            Spacer()
                        }.padding()
                            .padding(.top, 50)
                        VStack(alignment: .leading){
                            ButtonNavbar(index: $index, menu: $menu,whereto: "Home", img: "house" , title: "Menu Principal").padding(.leading,widthMenu == 375 ? 25 : 32).padding(.bottom,10)
                            ButtonNavbar(index: $index, menu: $menu,whereto: "SettingsView", img: "gearshape.fill", title: "Configuración").padding(.bottom,10).padding(.leading,widthMenu == 375 ? 15 : 16)
                            ButtonNavbar(index: $index, menu: $menu,whereto: "GeneralDataView", img: "person.crop.circle", title: "Datos Generales").padding(.bottom,10).padding(.leading,widthMenu == 375 ? 15 : 21)
                            ButtonNavbar(index: $index, menu: $menu,whereto: "FrecuentlyAskedQuestionsView", img: "checkmark" , title: "Preguntas Frecuentes").padding(.bottom,10).padding(.leading,widthMenu == 375 ? 15 : 21)
                            Spacer()
                            Button(action: {
                                try! Auth.auth().signOut()
                                UserDefaults.standard.removeObject(forKey: "sesion")
                                loginShow.data = nil
                                loginShow.reminds = []
                                loginShow.medics = []
                                loginShow.meds = []
                                loginShow.medUpdate = nil
                                loginShow.remindUpdate = nil
                                loginShow.show = "Login"
                            }){
                                Text("Sign Out").font(.title).fontWeight(.bold).foregroundColor(.blue)
                            }.padding(.all).padding(.leading, 30).padding(.bottom, 20)
                        }
                        Spacer()
                    }.frame(width: widthMenu-200).background(Color("BlueBBVA"))
                }
                
            }
            
        }
    }
}
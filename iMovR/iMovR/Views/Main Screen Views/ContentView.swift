//
//  ContentView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/13/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var BTController: DeviceBluetoothManager
 
    var body: some View {
        
        TabView(selection: $selection){
            
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                //HomeView()
                HomeViewV2(zipdeskUI: BTController.zipdesk)
            }
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            
            
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                DeviceManagerView()
                    //.padding(20)
            }
                .tabItem {
                    VStack {
                        Image(systemName: "studentdesk")
                        //"books.vertical.fill") shippingbox.fill; latch.2.case.fill; printer.fill; ...
                        Text("Devices")
                            //.font(.title)
                    }
                }
                .tag(1)
            
            
            SettingView()
                
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape.2.fill")
                        Text("Settings")
                    }
                }
                .tag(2)
            
//            BTConnectView(showBTConnect: .constant(true))
//                .tabItem {
//                    VStack {
//                        Image(systemName: "bolt.horizontal.fill")
//                        Text("BT TEST")
//                    }
//                }
//                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
                .environmentObject(UserObservable())
                .environmentObject(DeviceBluetoothManager())
    }
}

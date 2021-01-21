//
//  ContentView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/13/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var BTController: DeviceBluetoothManager
    
    @State private var selection = 0
 
    var body: some View {
        
        TabView(selection: $selection){
            
            // Home Page Tab
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                HomeViewV2(zipdeskUI: BTController.zipdesk, data: BTController.data)
                    .onAppear() {
                        // Enable autoconnect
                        if self.BTController.data.connectedDeskIndex == nil {
                            self.BTController.scanForDevices()
                        } else {
                            self.BTController.stopScan()
                        }
                    }
                    
                    .onDisappear() {
                        // Desk safety
                        self.BTController.zipdesk.releaseDesk()
                    }
            }.tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }.tag(0)
            
            
            // Device Manager Tab
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                DeviceManagerView(data: BTController.data)
                    .onAppear() {
                        self.BTController.scanForDevices()
                    }.onDisappear() {
                        self.BTController.stopScan()
                    }
            }.tabItem {
                VStack {
                    Image(systemName: "studentdesk")
                    //"books.vertical.fill") shippingbox.fill; latch.2.case.fill; printer.fill; ...
                    Text("Devices")
                        //.font(.title)
                }
            }.tag(1)
            
            
//            // Settings Page Tab
//            SettingView().tabItem {
//                VStack {
//                    Image(systemName: "gearshape.2.fill")
//                    Text("Settings")
//                }
//            }.tag(2)
            
        }// end TabView
            // Desk safety when user sends app to background or reopens app.
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                print("app moving to background; stopping desk")
                self.BTController.zipdesk.releaseDesk()
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                print("app returning to foreground; request current heights")
                self.BTController.zipdesk.releaseDesk()
                self.BTController.zipdesk.requestHeightsFromDesk()
            })
        
    }// end body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return Group {
            ContentView().environment(\.managedObjectContext, context)
                .environmentObject(DeviceBluetoothManager())
                .previewDevice("iPhone 11")
            ContentView().environment(\.managedObjectContext, context)
                .environmentObject(DeviceBluetoothManager())
                .previewDevice("iPhone 6s")
        }
    }
}

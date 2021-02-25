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
    
    @State private var b1 = false
    @State private var b2 = false
    @State private var b3 = false
    @State private var b4 = false
    @State private var b5 = false
    @State private var b6 = false
    var Pressed = Image("buttonPressed")
    var Unpressed = Image("buttonUnpressed")
 
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
                        if BTController.data.connectedDeskIndex != nil {
                            self.BTController.stopScan()
                        }
                    }
            }.tabItem {
                VStack {
                    Image(systemName: "studentdesk")
                    //"books.vertical.fill") shippingbox.fill; latch.2.case.fill; printer.fill; ...
                    Text("Devices")
                        //.font(.title)
                }
            }.tag(1)

            // graphics test tab
            ZStack {
                Image("appBackgroundPNG")
                    .resizable()
                    .scaledToFill()
                .ignoresSafeArea(edges: .top)
                VStack {
                    Text("Default button size")
                        .font(.title)
                        .foregroundColor(.white)
                    HStack {
//                        Button(action:{}) {
//                            (b1 ? Unpressed:Pressed)
//                            .resizable()
//                            .frame(width: 140, height: 140)
//                        }
//                        .simultaneousGesture (
                        
                        (b1 ? Unpressed:Pressed)
                            .resizable()
                            .frame(width: 140, height: 140)
                            .gesture (
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        b1 = true
                                    })
                                    .onEnded({ _ in
                                        b1 = false
                                    })
                            )
//                            .buttonStyle(PlainButtonStyle())
                        
                        (b2 ? Pressed:Unpressed)
                            .resizable()
                            .frame(width: 140, height: 140)
                            .gesture (
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        b2 = true
                                    })
                                    .onEnded({ _ in
                                        b2 = false
                                    })
                            )
                    }
                    
                    Spacer()
                    
                    Text("Small button size")
                        .font(.title)
                        .foregroundColor(.white)
                    HStack {
                        (b3 ? Unpressed:Pressed)
                            .resizable()
                            .frame(width: 105, height: 105)
                            .gesture (
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        b3 = true
                                    })
                                    .onEnded({ _ in
                                        b3 = false
                                    })
                            )
                        
                        (b4 ? Pressed:Unpressed)
                            .resizable()
                            .frame(width: 105, height: 105)
                            .gesture (
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        b4 = true
                                    })
                                    .onEnded({ _ in
                                        b4 = false
                                    })
                            )
                    }
                    
                    Spacer()
                    
                    Text("Large button size")
                        .font(.title)
                        .foregroundColor(.white)
                    HStack {
                        (b5 ? Unpressed:Pressed)
                            .resizable()
                            .frame(width: 210, height: 210)
                            .gesture (
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        b5 = true
                                    })
                                    .onEnded({ _ in
                                        b5 = false
                                    })
                            )
                        
                        (b6 ? Pressed:Unpressed)
                            .resizable()
                            .frame(width: 210, height: 210)
                            .gesture (
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        b6 = true
                                    })
                                    .onEnded({ _ in
                                        b6 = false
                                    })
                            )
                    }
                    
                }
                .padding([.top, .bottom], 50)
                
            }
//            .background (
//                Image("appBackground")
//                    .resizable()
//            )
            .tabItem {
                VStack {
                    Image(systemName:"gearshape")
                    Text("GFX Test")
                }
            }.tag(2)
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
                .previewDevice("iPhone 12")
//            ContentView().environment(\.managedObjectContext, context)
//                .environmentObject(DeviceBluetoothManager())
//                .previewDevice("iPhone 6s")
        }
    }
}

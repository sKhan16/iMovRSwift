//
//  SaveDeviceView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/27/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct SaveDeviceView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @EnvironmentObject var user: UserObservable
    
    @Binding var deviceIndex: Int
    var selectedDevice: Desk
    @State var showWarning: Bool = false
    
    //    init(deviceIndex: Binding<Int>, selectedDevice: Desk){
    //        self._deviceIndex = deviceIndex
    //        self.selectedDevice = selectedDevice
    //        UITableView.appearance().backgroundColor = .clear
    //    }
    
    @State var newName: String = ""
    
    var body: some View {
        ZStack{
            // Background color filter & back button
            Button(action: {self.deviceIndex = -1}, label: {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
                //.blur(radius: 3.0)
            })
            VStack {
                
                VStack {
                    ZStack {
                        Text("New Device")
                            .font(Font.title.weight(.medium))
                            .padding(5)
                        Button(action: {self.deviceIndex = -1}, label: {
                            Text("Back")
                                .font(Font.caption)
                                .frame(width: 50, height: 28)
                                .offset(x:-1)
                                .background(Color.red)
                                .cornerRadius(13)
                                .shadow(radius: 3)
                            
                            
                        })
                        .offset(x: -116, y: -14)
                    }
                    Rectangle()
                        .foregroundColor(Color.black)
                        .frame(maxWidth:.infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                    VStack {
                        Text(selectedDevice.name)
                            .font(Font.title3.weight(.medium))
                        Text("ZipDesk ID: " + String(selectedDevice.id))
                            .font(Font.body.monospacedDigit().weight(.regular))
                            .padding(.top,1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    //.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    //.padding([.leading,.trailing])
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("Please name your device:")
                        .foregroundColor(Color.white)
                        .font(Font.body.weight(.medium))
                        .offset(y:8)
                    TextField(" new name", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    /*
                     Text("Device ID:")
                     .foregroundColor(Color.white)
                     .font(Font.body.weight(.medium))
                     .padding(.top, 10)
                     .offset(y:8)
                     TextField("change id?", text: $editID)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     */
                }
                .padding()
                Spacer()
                
                if showWarning {
                    Text("You must name this device\n to save and connect to it.")
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.body.bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.red)
                        .padding(10)
                        .background(ColorManager.gray.opacity(0.35))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                Button(action: {
                    print("saving new device")
                    var newDevice = self.selectedDevice
                    guard newName != "" else {
                        print("save new device error: no name given")
                        self.showWarning = true
                        return
                    }
                    newDevice.name = newName
                    self.bt.savedDevices.append(newDevice)
                    self.bt.discoveredDevices.remove(at: deviceIndex)
                    // perform userObservable save function here for coreData
                    self.showWarning = false
                    self.deviceIndex = -1
                    
                }, label: {
                    Text("Save Changes")
                        .font(Font.title3.bold())
                        .foregroundColor(Color.white)
                        .padding()
                        .background(ColorManager.preset)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                })
                .frame(width:200,height:100)
                
                
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
        }//end ZStack
        //.onTapGesture { self.deviceIndex = -1 }
        // Goes back when tapped outside of edit window
    }//end Body
}

struct SaveDeviceView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
            
            SaveDeviceView(deviceIndex: .constant(0), selectedDevice: Desk(name: "Discovered ZipDesk", deskID: 12345678))
        }
    }
}

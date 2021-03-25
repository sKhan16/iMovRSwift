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
    
    @Binding var deviceIndex: Int
    var selectedDevice: Desk
    
    @State var showWarning: Bool = false
    @State var newName: String = ""
    
    var body: some View {
        ZStack{
            // Background back button/color filter
            Button (
                action: { self.deviceIndex = -1 },
                label: {
                    Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
                }
            )
            VStack {
                
                VStack {
                    ZStack {
                        Text("New Device")
                            .font(Font.title.weight(.medium))
                            .foregroundColor(ColorManager.buttonPressed)
                            .padding(5)
//                        Button (
//                            action: {self.deviceIndex = -1},
//                            label: {
//                                Image(systemName: "trash")
//                                    .font(.system(size: 20.0))
//                                    .frame(width: 55, height: 25)
//                                .offset(x:-1)
//                                .background(Color.red)
//                                .cornerRadius(13)
//                                .shadow(radius: 3)
//                        } )
//                        .offset(x: 116, y: -14)
                    }
                    Rectangle()
                        .foregroundColor(ColorManager.buttonStatic)
                        .frame(maxWidth:.infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                    VStack {
                        Text("Discovered device")
                            .font(Font.title3.weight(.medium))
                            .foregroundColor(ColorManager.buttonPressed)
                        Text("Device ID: " + String(selectedDevice.id))
                            .font(Font.body.monospacedDigit().weight(.regular))
                            .foregroundColor(ColorManager.buttonPressed)
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
                        .foregroundColor(ColorManager.buttonPressed)
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
                    guard newName != "" else {
                        print("save new device error: no name given")
                        self.showWarning = true
                        return
                    }
                    
                    var newDevice = self.selectedDevice
                    newDevice.name = newName
                    
                    if (self.bt.data.addDevice(desk: newDevice)) {
                        self.bt.discoveredDevices.remove(at: deviceIndex)
                        self.bt.scanForDevices()
//                        if let savedDeviceIndex: Int = bt.data.savedDevices.firstIndex(
//                            where: { (newSavedDevice: Desk) -> Bool in
//                                newSavedDevice.id == newDevice.id
//                            })
//                        {
//
////*********************************************************************
//// I think code here needs to change, check related git commit comment
////*********************************************************************
//                            let didConnect = bt.connectToDevice (
//                                    device: newDevice,
//                                    savedIndex: savedDeviceIndex )
//                            print("saved new device: did connect - \(didConnect)")
//                        }
                    }
                    self.showWarning = false
                    self.deviceIndex = -1
                    
                }, // end save button action
                label: {
                    Text("Save")
                        .font(Font.title2.bold())
                        .foregroundColor(Color.white)
                        .frame(width: 125, height: 45)
                        //.padding()
                        .background(ColorManager.yesGreen)
                        .cornerRadius(8)
                        .shadow(radius: 8)
                } ) // end save button.
                .padding(.top, 35)
                
                Spacer()
                
                Button (
                    action: {self.deviceIndex = -1},
                    label: {
                        Text("Cancel")
                            .font(Font.title2.bold())
                            .foregroundColor(ColorManager.gray)
                            .frame(width: 125, height: 45)
                            .background(ColorManager.buttonPressed)
                            .cornerRadius(8)
                    }
                )
                .padding(.bottom, 45)
                //.frame(width:200,height:100)
                
                
            } // end top-level VStack
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
        }//end ZStack
    }//end Body
    
}


struct SaveDeviceView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
            
            SaveDeviceView(deviceIndex: .constant(0), selectedDevice: Desk(name:"Main Office Desk",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false))
        }
    }
}

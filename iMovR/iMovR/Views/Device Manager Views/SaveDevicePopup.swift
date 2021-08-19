//
//  SaveDevicePopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/27/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct SaveDevicePopup: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var deviceIndex: Int
    var selectedDevice: Desk
    
    @State var showWarning: Bool = false
    @State var newName: String = ""
    
    var body: some View {
        ZStack {
            if !self.isDeviceValid()
            {
                EmptyView()
            }
            else
            {
                // Background back button/gray color filter
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
                        Text("New Device")
                            .font(Font.title.weight(.medium))
                            .foregroundColor(ColorManager.buttonPressed)
                            .padding(5)
                        Rectangle()
                            .foregroundColor(ColorManager.buttonStatic)
                            .frame(maxWidth:.infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                        VStack {
                            Text("Discovered Device")
                                .font(Font.title3.weight(.medium))
                                .foregroundColor(ColorManager.buttonPressed)
                            Text("Device ID: " + String(selectedDevice.id))
                                .font(Font.body.monospacedDigit().weight(.regular))
                                .foregroundColor(ColorManager.buttonPressed)
                                .padding(.top,1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
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
                    
                    Button (
                        action:
                        {
                            guard newName != "" else {
                                print("save new device error: no name given")
                                self.showWarning = true
                                return
                            }
                            
                            print("saving new device")
                            var newDevice = self.selectedDevice
                            newDevice.name = newName
                            
                            if self.bt.data.addDevice(desk: newDevice)
                            {
                                //self.bt.discoveredDevices.remove(at: deviceIndex)
                                //self.bt.scanForDevices(repeating: true)
                            }
                            self.showWarning = false
                            self.deviceIndex = -1
                            
                        },
                        label:
                        {
                            Text("Save")
                                .font(Font.title2.bold())
                                .foregroundColor(Color.white)
                                .frame(width: 125, height: 45)
                                .background(ColorManager.yesGreen)
                                .cornerRadius(8)
                        }
                    ) // end save button
                    .padding(.top, 35)
                    
                    Spacer()
                    
                    Button (
                        action: {self.deviceIndex = -1},
                        label:
                        {
                            Text("Cancel")
                                .font(Font.title2.bold())
                                .foregroundColor(ColorManager.gray)
                                .frame(width: 125, height: 45)
                                .background(ColorManager.buttonPressed)
                                .cornerRadius(8)
                        }
                    )
                    .padding(.bottom, 45)
                    
                } // end top-level VStack
                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                .padding()
            }//end if/else
        }//end ZStack
    }//end Body
    
    func isDeviceValid() -> Bool
    {
        guard deviceIndex != -1,
              deviceIndex < bt.discoveredDevices.count,
              selectedDevice.id == bt.discoveredDevices[deviceIndex].id
        else {
            self.deviceIndex = -1
            return false
        }
        return true
    }
    
}


struct SaveDevicePopup_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
            
            SaveDevicePopup(deviceIndex: .constant(0), selectedDevice: Desk(name:"Main Office Desk",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false))
        }
    }
}

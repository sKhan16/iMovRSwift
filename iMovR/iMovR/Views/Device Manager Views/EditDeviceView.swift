//
//  EditDeviceView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EditDeviceView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var deviceIndex: Int
    var selectedDevice: Desk
    
    @State private var confirmDeleteMenu: Bool = false
    @State private var editName: String = ""
    
//    init(deviceIndex: Binding<Int>, selectedDevice: Desk){
//        self._deviceIndex = deviceIndex
//        self.selectedDevice = selectedDevice
//        UITableView.appearance().backgroundColor = .clear
//    }
    
    
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
                
                // Header
                VStack {
                    
                    ZStack {
                        Text("Edit Device")
                            .font(Font.title.weight(.medium).monospacedDigit())
                        Button (
                            action: {self.deviceIndex = -1},
                            label: {
                                Text("Back")
                                    .font(Font.caption)
                                    .frame(width: 40, height: 25)
                                    .background(Color.red)
                                    .cornerRadius(8, antialiased: true)
                            }
                        )
                        .offset(x: -115, y: 0)
                    }
                    .padding(.top, 10)

                    VStack {
                        Text(selectedDevice.name)
                            .font(Font.title3.weight(.medium))
                            .offset(y: 3)
                        Text("ZipDesk ID: " + String(selectedDevice.id))
                            .font(Font.body.monospacedDigit())
                            .padding(.top,1)
                            .offset(y: -2)
                    }
                    .frame(maxWidth: .infinity)
                    .background(ColorManager.deviceBG)
                    .cornerRadius(10)
                    .padding([.bottom,.leading,.trailing],10)
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                
                
                // Content
                if !confirmDeleteMenu {
                    VStack(alignment: .leading) {
                        Text("Edit Name")
                            .foregroundColor(Color.white)
                            .font(Font.body.weight(.medium))
                            .offset(y:8)
                        TextField(self.selectedDevice.name, text: $editName)
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
                    .padding([.bottom,.leading,.trailing],20)
                    
                    Button (
                        action: { self.confirmDeleteMenu = true },
                        label: {
                            Text("Delete Device")
                                .font(Font.headline)
                                .foregroundColor(Color.white)
                                .frame(width: 125, height: 30)
                                .background(ColorManager.deviceBG)
                                .cornerRadius(8)
                        }
                    )
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    Button(
                        action: {
                            print("saving 'edit device' changes")
                            var changedDevice = self.selectedDevice
                            changedDevice.name = editName
                            self.bt.data.editDevice(desk: changedDevice)
                            self.deviceIndex = -1
                        },
                        label: {
                            Text("Save Changes")
                                .font(Font.title2.bold())
                                .foregroundColor(Color.white)
                                .frame(width: 170, height: 55)
                                .background(ColorManager.yesGreen)
                                .cornerRadius(15)
                        }
                    )
                    .padding(.bottom, 50)
                    
                } else { // Confirm Delete Menu
                    VStack {
                        VStack {
                            Text("Are you sure you want to delete this device?")
                                .multilineTextAlignment(.center)
                                .font(Font.title2.bold())
                            Text("Saved presets will be lost.")
                                .multilineTextAlignment(.center)
                                .offset(y: 6)
                        }
                        .foregroundColor(.white)
                        .padding(15)
                        
                        
                        Button (
                            action: {
                                self.confirmDeleteMenu = false
                            },
                            label: {
                                Text("Keep Device")
                                    .font(Font.headline)
                                    .foregroundColor(Color.white)
                                    .frame(width: 130, height: 50)
                                    .background(ColorManager.yesGreen)
                                    .cornerRadius(8)
                            }
                        )
                        .padding(.top, 15)
                        
                        
                        Button (
                            action: {
                                self.confirmDeleteMenu = false
                                if self.deviceIndex == self.bt.data.connectedDeskIndex {
                                    guard self.bt.disconnectFromDevice(device: self.bt.data.savedDevices[self.deviceIndex], savedIndex: self.deviceIndex) else {
                                            print("")
                                            return
                                    }
                                }
                                let tempIndex: Int = self.deviceIndex
                                self.deviceIndex = -1
                                self.bt.data.deleteDevice(desk: self.selectedDevice, savedIndex: tempIndex)
//                                self.bt.scanForDevices()
                            },
                            label: {
                                Text("Delete")
                                    .font(Font.headline)
                                    .foregroundColor(Color.white)
                                    .frame(width: 100, height: 40)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                        )
                        .padding(.top, 35)
                        
                        Spacer()
                        
                    }
                }// end ConfirmDeleteMenu
                
            }// end VStack
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor).shadow(color: ColorManager.gray, radius: 2))
            //.overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 1))
            .padding()

        }//end ZStack
        //.onTapGesture { self.deviceIndex = -1 }
        // Goes back when tapped outside of edit window
    }//end Body
}

struct EditDeviceView_Previews: PreviewProvider {

    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
        
            EditDeviceView(deviceIndex: .constant(0), selectedDevice: Desk(name: "Office Desk 1", deskID: 12345678, presetHeights:[], presetNames: [], isLastConnected: false))
        }
    }
}

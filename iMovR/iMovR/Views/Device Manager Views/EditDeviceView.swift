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
                            .font(Font.title.weight(.medium)
                            .monospacedDigit())
                            .foregroundColor(ColorManager.buttonPressed)
                        Button (
                            action: {self.confirmDeleteMenu = true},
                            label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 20.0))
                                    .frame(width: 55, height: 25)
                                    .background(Color.red)
                                    .cornerRadius(8, antialiased: true)
                            }
                        )
                        .offset(x: 115, y: 0)
                    }
                    .padding(.top, 10)

                    VStack {
                        Text(selectedDevice.name)
                            .font(Font.title3.weight(.medium))
                            .foregroundColor(ColorManager.buttonPressed)
                            .offset(y: 3)
                        Text("ZipDesk ID: " + String(selectedDevice.id))
                            .font(Font.body.monospacedDigit())
                            .foregroundColor(ColorManager.buttonPressed)
                            .padding(.top,1)
                            .offset(y: -2)
                    }
                    .frame(maxWidth: .infinity)
                    .background(ColorManager.gray)
                    .cornerRadius(10)
                    .padding([.bottom,.leading,.trailing],10)
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                
                
                // Content
                if !confirmDeleteMenu {
                    VStack(alignment: .leading) {
                        Text("Edit Name")
                            .foregroundColor(ColorManager.buttonPressed)
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
                        action: {self.deviceIndex = -1},
                        label: {
                            Text("Cancel")
                                .font(Font.headline)
                                .foregroundColor(ColorManager.buttonPressed)
                                .frame(width: 125, height: 30)
                                .background(ColorManager.gray)
                                .cornerRadius(8)
                        }
                    )
                    .padding(.top, 55)
                    
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
                        
                        
//I can do this by using the indexBinding in DevicePicker, by using a .onChange(devicePickerIndex) in DevicePicker
                        Button (
                            action: {
                                self.confirmDeleteMenu = false
                                
                                // Adjust device indices when removing a saved device
                                // Stage devicePickerIndex
                                bt.data.devicePickerIndex = nil
                            /*
                                if self.bt.data.devicePickerIndex != nil
                                {
                                    if self.deviceIndex == self.bt.data.devicePickerIndex
                                    {
                                        self.bt.data.devicePickerIndex = nil
                                    }
                                    else if self.deviceIndex < self.bt.data.devicePickerIndex!
                                    {
                                        self.bt.data.connectedDeskIndex! -= 1
                                    }
                                }
                            */
                                // Move connectedDeskIndex
                                if self.bt.data.connectedDeskIndex != nil
                                {
                                    if self.deviceIndex == self.bt.data.connectedDeskIndex
                                    {
                                        guard self.bt.disconnectFromDevice (
                                                device: self.bt.data.savedDevices[self.deviceIndex],
                                                savedIndex: self.deviceIndex )
                                        else
                                        {
                                            print("delete device failed to disconnect")
                                            return
                                        }
                                        self.bt.data.connectedDeskIndex = nil
                                    }
                                    else if self.deviceIndex < self.bt.data.connectedDeskIndex!
                                    {
                                        self.bt.data.connectedDeskIndex! -= 1
                                    }
                                } // End indices adjustments
                                
                                let tempIndex: Int = self.deviceIndex
                                self.deviceIndex = -1
                                // Delete this selected device
                                self.bt.data.deleteDevice(desk: self.selectedDevice, savedIndex: tempIndex)
                                self.bt.scanForDevices()
                                
                                // Set devicePickerIndex post-delete.
                                _=self.bt.data.setPickerIndex(decrement: true)
                                
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
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white).shadow(color: ColorManager.gray, radius: 2))
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

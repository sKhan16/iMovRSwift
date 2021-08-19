//
//  EditDevicePopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EditDevicePopup: View {
    
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
            })
            
            VStack // Main content:
            {
                VStack // Header
                {
                    ZStack
                    {
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
                        Text("ID: " + String(selectedDevice.id))
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
                
                
                if !confirmDeleteMenu
                { // Edit Device Menu
                    VStack(alignment: .leading)
                    {
                        Text("Edit Name")
                            .foregroundColor(ColorManager.buttonPressed)
                            .font(Font.body.weight(.medium))
                            .offset(y:8)
                        TextField(self.selectedDevice.name, text: $editName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                        .padding([.bottom,.leading,.trailing],20)
                    
                    Button(
                        action: {
                            print("saving 'edit device' changes")
                            var changedDevice = self.selectedDevice
                            changedDevice.name = editName
                            self.bt.data.editDevice(desk: changedDevice)
                            self.deviceIndex = -1
                        },
                        label: {
                            Text("Save")
                                .font(Font.title2.bold())
                                .foregroundColor(Color.white)
                                .frame(width: 125, height: 45)
                                .background(ColorManager.yesGreen)
                                .cornerRadius(8)
                        }
                    )
                    
                    .padding(.top, 55)
                    
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
                    .padding(.bottom, 55)
                    
                }
                else
                { // Confirm Delete Menu
                    VStack
                    {
                        VStack
                        {
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
                            action:
                            {
                                self.confirmDeleteMenu = false
                                
                                // Adjust various device selection indices when removing a saved device
                                bt.data.devicePickerIndex = nil
                                if self.bt.data.connectedDeskIndex != nil
                                {
                                    if self.deviceIndex == self.bt.data.connectedDeskIndex
                                    {
//                                        guard self.bt.disconnectFromDevice (
//                                                device: self.bt.data.savedDevices[self.deviceIndex],
//                                                savedIndex: self.deviceIndex )
//                                        else
//                                        {
//                                            print("delete device failed to disconnect")
//                                            return
//                                        }
                                        self.bt.data.connectedDeskIndex = nil
                                    }
                                    else if self.deviceIndex < self.bt.data.connectedDeskIndex!
                                    {
                                        self.bt.data.connectedDeskIndex! -= 1
                                    }
                                }
                                
                                // Delete this selected device
                                let tempIndex: Int = self.deviceIndex
                                self.deviceIndex = -1
                                self.bt.data.deleteDevice(desk: self.selectedDevice, savedIndex: tempIndex)
                                self.bt.scanForDevices()
                                
                                // reset devicePickerIndex after delete
                                _=self.bt.data.setPickerIndex(decrement: true)
                            },
                            label:
                            {
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
            .padding()

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

struct EditDevicePopup_Previews: PreviewProvider {

    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
        
            EditDevicePopup(deviceIndex: .constant(0), selectedDevice: Desk(name: "Office Desk 1", deskID: 12345678, presetHeights:[], presetNames: [], isLastConnected: false))
        }
    }
}

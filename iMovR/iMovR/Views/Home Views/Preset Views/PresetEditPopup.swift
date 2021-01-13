//
//  PresetEditPopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditPopup: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @EnvironmentObject var user: UserDataManager
    
    @Binding var show: Bool
    @Binding var isTouchGo: Bool
    @State private var tngLink: Bool = false
    
    @State private var showTnGPopup: Bool = false
    
    @State var editIndex: Int = -1
    @State var editPresetName: String = ""
    @State var editPresetHeight: String = ""
    @State var isInvalidInput: Bool = false
    
    
    
    var body: some View {
        ZStack {
            // Background color filter & back button
            Button(action: {self.show = false}, label: {
                Rectangle()
                    .fill(ColorManager.bgColor)
                    .opacity(0.75)
                    .edgesIgnoringSafeArea(.top)
            })
            
            VStack {
               // Display Presets List
                if bt.data.connectedDeskIndex == nil {
                    Text("Preset Settings")
                        .font(Font.title)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                    Text("Please Connect To A Device")
                        .font(Font.title2.bold())
                        .foregroundColor(.white)
                }
                
                else if self.editIndex == -1, bt.data.connectedDeskIndex != nil {
                    let currDesk: Desk = bt.data.savedDevices[bt.data.connectedDeskIndex!]
                    
                    VStack {
                        Text("Preset Settings")
                            .font(Font.title)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                        ForEach(Range(0...5)) { index in
                            VStack {
                                Button(action: { self.editIndex = index }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12).fill(ColorManager.deviceBG)
                                            .frame(height: 40)
                                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                                        
                                        Text(
                                            "Edit \(currDesk.presetNames[index]):  " +
                                            ((currDesk.presetHeights[index] > -1) ? String(currDesk.presetHeights[index]) : "Empty")
                                        )
                                        
                                    }
                                })
                                .accentColor(.white)
                                .padding([.leading, .trailing], 30)
                                .padding([.top, .bottom], 5)
                            }
                        }
                    }
                    .padding([.top,.bottom], 5)
                    
                    TnGToggle (isTouchGo: self.$isTouchGo, showTnGPopup: self.$showTnGPopup)
                        .padding(5)
                    
                    
                } else {
                    let currDesk: Desk = bt.data.savedDevices[bt.data.connectedDeskIndex!]
                    VStack(alignment: .center) {
                        Text("Edit Preset")
                            .foregroundColor(Color.white)
                            .font(Font.title)
                            .padding(.top, 5)
                        VStack(alignment: .leading) {
                            Text("Name")
                                .foregroundColor(Color.white)
                                .font(Font.headline)
                                .offset(y:6)
                            TextField(" \(currDesk.presetNames[self.editIndex])", text: $editPresetName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 5)
                            
                            Text("Height")
                                .foregroundColor(Color.white)
                                .font(Font.headline)
                                .offset(y:6)
                            /// Fix textfield to work with Float
                            TextField(" \(currDesk.presetHeights[self.editIndex], specifier: "%.1f")", text: self.$editPresetHeight)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                    }
                    .padding()
                    editSaveButton(data: self.bt.data, presetName: self.$editPresetName, presetHeight: self.$editPresetHeight, isInvalidInput: self.$isInvalidInput, editIndex: self.$editIndex)
                }
            } //end main level VStack
            .frame(idealWidth: 300, maxWidth: 300, idealHeight: 450, maxHeight: 450, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
            
            if self.showTnGPopup {
                TouchNGoPopup(isTouchGo: self.$isTouchGo, showTnGPopup: self.$showTnGPopup)
            }
        }//end ZStack
    }//end Body
}


private struct editSaveButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    
    @Binding var presetName: String
    @Binding var presetHeight: String
    @Binding var isInvalidInput: Bool
    @Binding var editIndex: Int
    
    var body: some View {
        Button(action: {
            guard bt.data.connectedDeskIndex != nil else {
                print("PresetEditPopup error: changes not saved, no desk connected")
                self.editIndex = -1
                return
            }
            var currDesk: Desk = data.savedDevices[data.connectedDeskIndex!]
            
            if (self.presetHeight != "") {
                let height: Float = (self.presetHeight as NSString).floatValue
                if height <= (self.bt.zipdesk.maxHeight) && height >= (self.bt.zipdesk.minHeight) {
                    if (self.presetName != "") {
                        currDesk.presetNames[self.editIndex] = self.presetName
                    }
                    currDesk.presetHeights[self.editIndex] = height
                    self.data.editDevice(desk: currDesk)
                    if currDesk.id == bt.zipdesk.getDesk().id,
                        currDesk.peripheral?.identifier == bt.zipdesk.getPeripheral()?.identifier
                    {
                        bt.zipdesk.setDesk(connectedDesk: currDesk)
                    }
                    self.isInvalidInput = false
                    self.editIndex = -1
                } else {
                    self.isInvalidInput = true
                    print("height out of bounds!")
                }
            } else if (self.presetName != "") {
                currDesk.presetNames[self.editIndex] = self.presetName
                self.bt.data.editDevice(desk: currDesk)
                self.editIndex = -1
            }
        }, label: {
            Text("Save Changes")
                .font(Font.title3.bold())
                .foregroundColor(Color.white)
                .padding()
                .background(ColorManager.preset)
                .cornerRadius(27)
        })
        .frame(width:200,height:100)
    }
}




struct PresetEditPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            PresetEditPopup (
                show: .constant(true),
                isTouchGo: .constant(true)
            )
            .environmentObject(UserDataManager())
            .environmentObject(DeviceBluetoothManager(previewMode: true)!)
        }
    }
}

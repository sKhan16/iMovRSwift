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
    
    @Binding var show: Bool
    @Binding var isTouchGo: Bool
    @Binding var showTNGWarningPopup: Bool
    
    @State var editIndex: Int = -1
    @State var editPresetName: String = ""
    @State var editPresetHeight: String = ""
    @State var isInvalidInput: Bool = false
    
    var body: some View {
        ZStack {
            // Background color filter & back button
            Button(action: {self.show = false}, label: {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
            })
            VStack {
               // Display Presets List
                if self.editIndex == -1, bt.data.connectedDeskIndex != nil {
                    let currDesk: Desk = bt.data.savedDevices[bt.data.connectedDeskIndex!]
                    VStack {
                        Text("Preset Settings")
                            .font(Font.title2)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                        ForEach(Range(0...5)) { index in
                            VStack {
                                Button(action: { self.editIndex = index }, label: {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 12).fill(ColorManager.deviceBG)
                                            .frame(height: 40)
                                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                                        
                                        HStack {
                                            Text("Edit \(currDesk.presetNames[index]):")
                                            Text( (currDesk.presetHeights[index] > -1) ? String(currDesk.presetHeights[index]) : "Empty")
                                        }
                                        
                                    }
                                })
                                .accentColor(.white)
                                .padding([.leading, .trailing], 30)
                                .padding([.top, .bottom], 5)
                            }
                        }
                    }
                    .padding(.top, 5)
                    MovementButton(isTouchGo: self.$isTouchGo)
                        .padding(.bottom)
                } else {
                    VStack(alignment: .leading) {
                        Text("Change Preset Name?")
                            .foregroundColor(Color.white)
                            .font(Font.body.weight(.medium))
                            .offset(y:8)
                        VStack(alignment: .leading) {
                            Text("Change Preset \(self.editIndex+1) Name?")
                                .foregroundColor(Color.white)
                                .font(Font.body.weight(.medium))
                                .offset(y:8)
                            TextField(" new name", text: $editPresetName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("Change Preset \(self.editIndex+1) Height?")
                                .foregroundColor(Color.white)
                                .font(Font.body.weight(.medium))
                                .offset(y:8)
                            /// Fix textfield to work with Float
                            TextField(" new height", text: self.$editPresetHeight)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                    }
                    .padding()
                    editSaveButton(data: self.bt.data, presetName: self.$editPresetName, presetHeight: self.$editPresetHeight, isInvalidInput: self.$isInvalidInput, editIndex: self.$editIndex)
                }
            } //end main level VStack
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
        }//end ZStack
    }//end Body
}


private struct editSaveButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
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
                isTouchGo: .constant(true),
                showTNGWarningPopup: .constant(false)
            )
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

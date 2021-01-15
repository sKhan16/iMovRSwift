//
//  SelectedPresetEditMenu.swift
//  iMovR
//
//  Created by Michael Humphrey on 1/14/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct SelectedPresetEditMenu: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var editIndex: Int
    
    @State private var editPresetName: String = ""
    @State private var editPresetHeight: String = ""
    
    @State private var showOldName: Bool = true
    @State private var showOldHeight: Bool = true
    
    @State private var isInvalidInput: Bool = false
    
    
    @ViewBuilder
    var body: some View {
        
        if bt.data.connectedDeskIndex == nil {
            EmptyView()
            //this is why we need @ViewBuilder -.- :C D:
        }
        else {
            
            let currDesk: Desk = bt.data.savedDevices[bt.data.connectedDeskIndex!]
            
            let getPresetName: Binding = Binding<String> (
                get: {
                    return (showOldName ? currDesk.presetNames[self.editIndex] : self.editPresetName)
                },
                set: {
                    let maxChars = 15
                    guard $0.count < maxChars else { // input length validation
                        return
                    }
                    self.editPresetName = showOldName ? currDesk.presetNames[self.editIndex] : $0
                }
            )
            
            let getPresetHeight: Binding = Binding<String> (
                get: {
                    return (showOldHeight ? String(format:"%.1f",currDesk.presetHeights[self.editIndex]) : self.editPresetHeight)
                },
                set: {
                    self.editPresetHeight = showOldHeight ? String(format:"%.1f",currDesk.presetHeights[self.editIndex]) : $0
                }
            )
            
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
                    
                    TextField (
                        " \(currDesk.presetNames[self.editIndex])",
                        text: getPresetName
                    )
                    { changing in
                        if changing {
                            if self.editPresetName == "" { // Preset height set to desk height
                                self.editPresetName = currDesk.presetNames[self.editIndex]
                            }
                            self.showOldName = false
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 5)
                    
                    Text("Height")
                        .foregroundColor(Color.white)
                        .font(Font.headline)
                        .offset(y:6)
                    /// Fix textfield to work with Float
                    TextField (
                        " \( (currDesk.presetHeights[self.editIndex] == -1.0) ? "Empty" : String(format:"%.1f",currDesk.presetHeights[self.editIndex]) )",
                        text: getPresetHeight
                    )
                    { changing in
                        if changing {
                            if self.editPresetHeight == "" { // Preset height set to desk height
                                self.editPresetHeight = String(format:"%.1f",currDesk.presetHeights[self.editIndex])
                            }
                            self.showOldHeight = false
                        }
                    }
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                EditSaveButton(presetName: self.$editPresetName, presetHeight: self.$editPresetHeight, isInvalidInput: self.$isInvalidInput, editIndex: self.$editIndex)
            }
            .padding()
            
            
        } // end top-level if/else
    } // end Body
} // end SelectedPresetEditMenu


private struct EditSaveButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    //@ObservedObject var data: DeviceDataManager
    
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
            var currDesk: Desk = bt.data.savedDevices[bt.data.connectedDeskIndex!]
            
            if (self.presetHeight != "") {
                let height: Float = (self.presetHeight as NSString).floatValue
                if height <= (self.bt.zipdesk.maxHeight) && height >= (self.bt.zipdesk.minHeight) {
                    if (self.presetName != "") {
                        currDesk.presetNames[self.editIndex] = self.presetName
                    }
                    currDesk.presetHeights[self.editIndex] = height
                    self.bt.data.editDevice(desk: currDesk)
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


struct SelectedPresetEditMenu_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPresetEditMenu(editIndex: .constant(0))
            .environmentObject(DeviceBluetoothManager(previewMode: true)!)
    }
}

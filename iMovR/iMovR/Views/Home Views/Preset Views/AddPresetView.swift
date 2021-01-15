//
//  AddPresetView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/20/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetView: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @State private var presetName: String = ""
    @State private var presetHeight: String = "" // doesnt andy want this to change so that it keeps the height...
    @State private var useDeskHeight: Bool = true
    @Binding var showAddPreset: Bool
    
    @State var isInvalidInput: Bool = false

    let index: Int

    var body: some View {
        
        let autoFillHeight = Binding<String> (
            get: { return (useDeskHeight ? String(format:"%.1f",self.bt.zipdesk.deskHeight) : self.presetHeight) },
            set: { self.presetHeight = useDeskHeight ? String(format:"%.1f",self.bt.zipdesk.deskHeight) : $0 }
        )
        
        NavigationView {
        //ZStack {
            VStack {
            //Text("New preset")
                Form {
                Section(header: Text("PRESET")) {
                    
                    TextField("Preset Name", text: $presetName)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    TextField (
                        "Preset Height",
                        text: autoFillHeight
                    )
                        { changing in
                            if changing {
                                if self.presetHeight == "" { // Preset height set to desk height
                                    self.presetHeight = String(format:"%.1f",self.bt.zipdesk.deskHeight)
                                }
                                self.useDeskHeight = false
                            }
                        }
                        .keyboardType(.decimalPad)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if (self.isInvalidInput) {
                        VStack {
                            Text("Invalid field entries.")
                            .foregroundColor(.red)
                            .padding()
                        }
                    }
                    }
                
                }
            }
            .navigationBarTitle(Text("New Preset"), displayMode: .inline)
            .navigationBarItems(
                leading: CloseButton(showSheet: self.$showAddPreset),
                trailing: doneButton(presetName: self.$presetName, presetHeight: self.$presetHeight, showAddPreset: self.$showAddPreset, isInvalidInput: self.$isInvalidInput, useDeskHeight: self.$useDeskHeight, index: self.index))
        }
    }
}

struct doneButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var presetName: String
    @Binding var presetHeight: String
    @Binding var showAddPreset: Bool
    @Binding var isInvalidInput: Bool
    @Binding var useDeskHeight: Bool

    let index: Int
    
    var body: some View {
        Button(action: {
            
            print("index \(index) in addPresetView")
            guard bt.data.connectedDeskIndex != nil else {
                print("AddPresetView error: changes not saved, no desk connected")
                self.showAddPreset = false
                return
            }
            let height: Float
            if useDeskHeight {
                height = self.bt.zipdesk.deskHeight
            } else {
                height = (self.presetHeight as NSString).floatValue
            }
            if height <= 48.00 && height >= 23.00 {
                self.isInvalidInput = false
                var currDesk: Desk = bt.data.savedDevices[bt.data.connectedDeskIndex!]
                currDesk.presetHeights[index] = height
                currDesk.presetNames[index] = self.presetName
                self.bt.data.editDevice(desk: currDesk)
                print("Height is \(height)")
                self.showAddPreset = false
            } else {
                self.isInvalidInput = true
                print("height out of bounds!")
            }
            
        }) {
            Text("Done").bold()
        }
    }
}


struct AddPresetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetView(showAddPreset: .constant(true), index: 0)
            .environmentObject(DeviceBluetoothManager(previewMode: true)!)
    }
}

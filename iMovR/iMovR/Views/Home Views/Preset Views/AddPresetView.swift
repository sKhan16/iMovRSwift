//
//  AddPresetView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/20/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetView: View {
    
    @State private var presetName: String = ""
    @State private var presetHeight: String = ""
    @Binding var showAddPreset: Bool
    @State var isInvalidInput: Bool = false

    let index: Int

    var body: some View {
        NavigationView {
        //ZStack {
            VStack {
            //Text("New preset")
                Form {
                Section(header: Text("PRESET")) {
                    
                    TextField("Preset Name", text: $presetName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Preset Height", text: $presetHeight)
                        .keyboardType(.decimalPad)
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
                trailing: doneButton(presetName: self.$presetName, presetHeight: self.$presetHeight, showAddPreset: self.$showAddPreset, isInvalidInput: self.$isInvalidInput, index: self.index))
        }
    }
}

struct doneButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
    @Binding var showAddPreset: Bool
    @Binding var isInvalidInput: Bool

    let index: Int
    
    var body: some View {
        Button(action: {
            
            print("index in addPresetView \(index)")
            
            let height: Float = (self.presetHeight as NSString).floatValue
            if height <= 48.00 && height >= 23.00 {
                self.isInvalidInput = false
                var currDesk: Desk = self.bt.zipdesk.getDesk()
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
    }
}

//
//  EditPreset.swift
//  iMovR
//
//  Created by Adrian Yue on 7/31/20.
//  Copyright © 2020 iMovR. All rights reserved.
//  Basically just AddPresetView but with some changes, edits a preset instead of adding
//  TODO: return to previous view once done and close is pressed
//  reduce gap on top of view; remove height?

import SwiftUI


struct EditPreset: View {
    
    @EnvironmentObject var user: UserObservable
    
    @State private var presetName: String = ""
    @State private var presetHeight: String = ""

    var currIndex: Int
    
    
    var body: some View {
 
        VStack {
            Form {
                Section(header:
                ///Must find a way to store in variable: done i think
                    
                Text(self.user.presets[self.currIndex].getName())) {
                    
                    TextField("\(self.user.presets[self.currIndex].getName())", text: $presetName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("\(self.user.presets[self.currIndex].getHeight())", text: $presetHeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                
                
            }
        }
        .navigationBarTitle(Text("Edit Preset"), displayMode: .inline)
        .navigationBarItems(trailing: editDoneButton(presetName: self.$presetName, presetHeight: self.$presetHeight, currIndex: self.currIndex))
    }
}


struct editDoneButton: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var user: UserObservable
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
    
   var currIndex: Int
    //@Binding var showAddPreset: Bool
    
    var body: some View {
        Button(action: {
            
            //Converts presetHeight to a float
            let height: Float = (self.presetHeight as NSString).floatValue
            
            if height <= 48.00 && height >= 23.00 {
                
                self.user.presets[self.currIndex].name = self.presetName
                self.user.presets[self.currIndex].height = height
                
                ///TODO: Fix bug where you have to click Done twice to return
                self.mode.wrappedValue.dismiss()
                
                print("Edited Name is \(self.presetHeight)")
                print("Edited Height is \(height)")
            } else {
                print("height out of bounds!")
            }
            //self.showAddPreset = false
            
        }) {
            Text("Done").bold()
        }
    }
}


struct EditPreset_Previews: PreviewProvider {
    static var previews: some View {
        EditPreset(currIndex: 0).environmentObject(UserObservable())
    }
}

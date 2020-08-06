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
    //@Binding var showAddPreset: Bool
    
    @State var currPreset: Preset
    
    
    var body: some View {
        
        //ZStack {
        VStack {
            //Text("New preset")
            Form {
                Section(header:
                ///Must find a way to store in variable
                Text(self.currPreset.getName())) {
                    
                    TextField("\(self.currPreset.getName())", text: $presetName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("\(self.currPreset.getHeight())", text: $presetHeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                
                
            }
        }
        .navigationBarTitle(Text("Edit Preset"), displayMode: .inline)
        .navigationBarItems(trailing: editDoneButton(presetName: self.$presetName, presetHeight: self.$presetHeight, currPreset: self.$currPreset))
    }
}


struct editDoneButton: View {
    @EnvironmentObject var user: UserObservable
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
    
   @Binding var currPreset: Preset
    //@Binding var showAddPreset: Bool
    
    var body: some View {
        Button(action: {
            
            let height: Float = (self.presetHeight as NSString).floatValue
            if height <= 48.00 && height >= 23.00 {
                //Create helper function to edit preset, with height
                //being optional
                self.currPreset.setName(name: self.presetName)
                self.currPreset.setHeight(height: height)
                
                //TODO: allow height edit, doesn't work right now
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
        EditPreset(currPreset: Preset(name: "test", height: 32.0)).environmentObject(UserObservable())
    }
}

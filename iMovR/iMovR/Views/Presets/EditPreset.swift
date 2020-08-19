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
    @State var isInvalidInput: Bool = false
    @State var isSaved: Bool = false
    
    var currIndex: Int
    
    
    var body: some View {
        
        VStack {
            Form {
                if currIndex < self.user.presets.count {
                    Section(header:
                        Text(self.user.presets[self.currIndex].getName())
                    ) {
                        
                        TextField("\(self.user.presets[self.currIndex].getName())", text: $presetName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("\(self.user.presets[self.currIndex].heightToStringf())", text: $presetHeight)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if (self.isInvalidInput) {
                            VStack {
                                Text("Invalid field entries.")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        if (self.isSaved) {
                            VStack {
                                Text("Your changes have been saved.")
                                    .foregroundColor(.green)
                                    .padding()
                                //Maybe add fade out animation
                            }
                        }
                        
                    }
                    
                } else {
                    Text("Preset index error")
                }
            }
        }
        .navigationBarTitle(Text("Edit Preset"), displayMode: .inline)
        .navigationBarItems(trailing: editSaveButton(presetName: self.$presetName, presetHeight: self.$presetHeight, isInvalidInput: self.$isInvalidInput, isSaved: self.$isSaved, currIndex: self.currIndex))
    }
}

struct editSaveButton: View {
    
    //@Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var user: UserObservable
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
    @Binding var isInvalidInput: Bool
    @Binding var isSaved: Bool
    
    var currIndex: Int
    
    var body: some View {
        Button(action: {
            if (self.presetHeight != "") {
                
                //Converts presetHeight to a float
                let height: Float = (self.presetHeight as NSString).floatValue
                
                //TODO: Change min and max to read values from desk
                if height <= 48.00 && height >= 23.00 {
                    
                    self.isInvalidInput = false
                    self.isSaved = true
                    
                    if (self.presetName != "") {
                        //self.user.presets[self.currIndex].name = self.presetName
                        self.user.editPreset(index: self.currIndex, name: self.presetName)
                    }
                    
                    //self.user.presets[self.currIndex].height = height
                    self.user.editPreset(index: self.currIndex, height: height)
                    
                    ///TODO: Fix bug where you have to click Done twice to return
                    //self.mode.wrappedValue.dismiss()
                    
                    print("Edited Name is \(self.presetHeight)")
                    print("Edited Height is \(height)")
                } else {
                    self.isInvalidInput = true
                    self.isSaved = false
                    print("height out of bounds!")
                }
                //self.showAddPreset = false
            } else if (self.presetName != "") {
                //self.user.presets[self.currIndex].name = self.presetName
                self.user.editPreset(index: self.currIndex, name: self.presetName)
                self.isSaved = true
            }
        }) {
            Text("Save").bold()
        }
    }
}


struct EditPreset_Previews: PreviewProvider {
    static var previews: some View {
        EditPreset(currIndex: 0).environmentObject(UserObservable())
    }
}

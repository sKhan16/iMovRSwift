//
//  EditDesk.swift
//  iMovR
//
//  Created by Adrian Yue on 8/7/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EditDesk: View {
    @EnvironmentObject var user: UserObservable
    
    @State private var deskName: String = ""
    @State private var deskID: Int = 0
    @State var isInvalidInput: Bool = false
    
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
                        
                    }
                    
                } else {
                    Text("Preset index error")
                }
            }
        }
        .navigationBarTitle(Text("Edit Preset"), displayMode: .inline)
        .navigationBarItems(trailing: editDoneButton(presetName: self.$presetName, presetHeight: self.$presetHeight, isInvalidInput: self.$isInvalidInput, currIndex: self.currIndex))
    }
}


struct editDoneButton: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var user: UserObservable
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
    @Binding var isInvalidInput: Bool
    var currIndex: Int
    //@Binding var showAddPreset: Bool
    
    var body: some View {
        Button(action: {
            
            //Converts presetHeight to a float
            let height: Float = (self.presetHeight as NSString).floatValue
            
            if height <= 48.00 && height >= 23.00 {
                
                self.isInvalidInput = false
                
                if (self.presetName != "") {
                    self.user.presets[self.currIndex].name = self.presetName
                }
                
                self.user.presets[self.currIndex].height = height
                
                ///TODO: Fix bug where you have to click Done twice to return
                self.mode.wrappedValue.dismiss()
                
                print("Edited Name is \(self.presetHeight)")
                print("Edited Height is \(height)")
            } else {
                self.isInvalidInput = true
                print("height out of bounds!")
            }
            //self.showAddPreset = false
            
        }) {
            Text("Done").bold()
        }
    }
}



struct EditDesk_Previews: PreviewProvider {
    static var previews: some View {
        EditDesk(currIndex: 0)
            .environmentObject(UserObservable())
    }
}

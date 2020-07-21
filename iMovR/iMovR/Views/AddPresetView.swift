//
//  AddPresetView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/20/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetView: View {
    
    @EnvironmentObject var user: UserObservable
    
    @State private var presetName: String = ""
    @State private var presetHeight: String = ""
    @Binding var showAddPreset: Bool
    
    var body: some View {
        //NavigationView {
        ZStack {
            VStack {
            Text("New preset")
                Form {
                Section(header: Text("PRESET")) {
                    TextField("Preset name", text: $presetName)
                    TextField("Preset Height", text: $presetHeight)
                        .keyboardType(.numberPad)
                }
            }
            //.navigationBarTitle("Add a Preset", displayMode: .inline)
            Button(action: {
                var height: Float = (self.presetHeight as NSString).floatValue
                if height <= 48.00 && height >= 23.00 {
                    self.user.addPreset(name: self.presetName, height: height)
                    print("Height is \(height)")
                } else {
                    print("height out of bounds!")
                }
                self.showAddPreset = false
            }) {
                Text("Done")
            }
        
            
            }
            
        }
        //.scaledToFill()
        .frame( height: 250)
        .cornerRadius(20).shadow(radius: 20)
    //.padding()
        
        //
        
    }
    //}
}

struct AddPresetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetView(showAddPreset: .constant(true)).environmentObject(UserObservable())
    }
}

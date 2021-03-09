//
//  AddPresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetButton: View {

    @Environment(\.colorScheme) var colorScheme
    
   var Unpressed = Image("ButtonRoundDark")
    var Pressed = Image("ButtonRoundDarkBG")

    @State private var testCount: Float = 0.0
    
    let index: Int

    @Binding var showAddPreset: Bool
    
    var body: some View {
        
            Button(action: {
                self.showAddPreset = true
                print("addPresetButton index \(self.index)")
            }) {
           
        VStack {
                ZStack {
                    PresetBG()
                    (self.showAddPreset ? Pressed : Unpressed)
                        .resizable()
                        .frame(minWidth: 85, idealWidth: 95, maxWidth: 95, minHeight: 85, idealHeight: 95, maxHeight: 95)
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.blue)
                }
                
        }
//        .foregroundColor(ColorManager.preset)
//        .accentColor(Color.white)
        
            
        }
            .sheet(isPresented: self.$showAddPreset) {
                AddPresetView(showAddPreset: self.$showAddPreset, index: self.index)
        }
    }

}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton(index: 0, showAddPreset: .constant(true))
    }
}

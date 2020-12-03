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
                    Circle()
                        //.resizable()
                        //.stroke(Color.black, lineWidth: 3)
                        //.background(Circle().foregroundColor(ColorManager.preset))
                        .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.white)
                }
                
        }
        .foregroundColor(ColorManager.preset)
        .accentColor(Color.white)
        
            
        }
            .sheet(isPresented: self.$showAddPreset) {
                AddPresetView(showAddPreset: self.$showAddPreset, index: self.index)
        }
    }

}

//func addPreset(user: UserObservable, name: String, height: Float) {
//    //Test code. Replace when neccessary. Can mutate observable object.
//    if user.addPr, index: <#Int#>eset(name: name, height: height, index: 0) {
//        print("preset successfully added")
//    } else {
//        print("user.addPreset failed")
//    }
//    // Replace with functionality to switch to AddPreset screen.
//    print("Moving to the add preset screen!")
//}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton(index: 0, showAddPreset: .constant(true))
    }
}

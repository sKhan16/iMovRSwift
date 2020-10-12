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
    @EnvironmentObject var user: UserObservable
    @State private var testCount: Float = 0.0

    @Binding var showAddPreset: Bool
    
    var body: some View {
        
            Button(action: {
                self.showAddPreset = true
            }) {
           
        VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        //.stroke(Color.black, lineWidth: 3)
                        //.background(Circle().foregroundColor(ColorManager.preset))
                        .frame(width: 80.0, height: 80)
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
                AddPresetView(showAddPreset: self.$showAddPreset).environmentObject(self.user)
        }
    }

}

func addPreset(user: UserObservable, name: String, height: Float) {
    //Test code. Replace when neccessary. Can mutate observable object.
    if user.addPreset(name: name, height: height) {
        print("preset successfully added")
    } else {
        print("user.addPreset failed")
    }
    // Replace with functionality to switch to AddPreset screen.
    print("Moving to the add preset screen!")
}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton(showAddPreset: .constant(true)).environmentObject(UserObservable())
    }
}

//
//  AddPresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetButton: View {
@EnvironmentObject var user: UserObservable
@State private var testCount: Float = 0.0
    
    var body: some View {
        
            Button(action: {
                addPreset(user: self.user, name: "test", height: self.testCount)
                self.testCount += 1.0
                
            }) {
            VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        .stroke(Color.gray, lineWidth: 3)
                        .frame(width: 45.0, height: 45)
                    Image(systemName: "plus")
                    .resizable()
                    .frame(width: 25, height: 25)
                    }
                Text("Add Preset")
            }
        }
            .accentColor(Color.black)
    }
}

func addPreset(user: UserObservable, name: String, height: Float) {
    //Test code. Replace when neccessary. Can mutate observable object.
    user.addPreset(name: name, height: height)
    // Replace with functionality to switch to AddPreset screen.
    print("Moving to the add preset screen!")
}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton()
    }
}

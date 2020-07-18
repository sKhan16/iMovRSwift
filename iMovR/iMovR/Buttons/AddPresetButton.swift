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
    
    var body: some View {
        
            Button(action: {
                addPreset(user: self.user)
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

func addPreset(user: UserObservable) {
    user.addTestPresets()
    // Replace with functionality to switch to AddPreset screen.
    print("Moving to the add preset screen!")
}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton()
    }
}

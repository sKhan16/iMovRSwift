//
//  UpButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct UpButton: View {
    @EnvironmentObject var bt: ZGoBluetoothController
    @Binding var testHeight: Float
    
    var body: some View {
        Button(action: {
            // What to perform
            self.bt.deskWrap?.raiseDesk()
            if self.testHeight < 48.0 {
                self.testHeight += 1.0
                print("Moving up!")
            } else {
                print("Reached maximum height")
            }
            
        }) {
            // How the button looks like
            Image(systemName: "arrow.up.square")
            .resizable()
            .frame(width: 75, height: 75)
        }
    }
}

struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        UpButton(testHeight: .constant(23.0)).environmentObject(ZGoBluetoothController())
    }
}

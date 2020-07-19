//
//  DownButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DownButton: View {
    @EnvironmentObject var bt: ZGoBluetoothController
    @Binding var testHeight: Float
    
    var body: some View {
        Button(action: {
            // What to perform
            self.bt.deskWrap?.lowerDesk()
            if self.testHeight > 23.0 {
                self.testHeight -= 1.0
                print("Moving down!")
            } else {
                print("Reached minimum height")
            }
            
        }) {
            // How the button looks like
            Image(systemName: "arrow.down.square")
            .resizable()
            .frame(width: 75, height: 75)
        }
    }
}


struct DownButton_Previews: PreviewProvider {
    static var previews: some View {
        DownButton(testHeight: .constant(23.0)).environmentObject(ZGoBluetoothController())
    }
}

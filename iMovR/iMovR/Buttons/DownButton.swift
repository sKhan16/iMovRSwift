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
    
    @State private var pressed: Bool = false
    @Binding var testHeight: Float
    
    var body: some View {
        Button(action: {
            // What to perform
            
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
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: CGFloat(25), pressing: { pressing in
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.pressed = pressing
                }
                if pressing {
                    self.bt.deskWrap?.lowerDesk()
                    print("My long pressed starts")
                    print("     I can initiate any action on start")
                } else {
                    self.bt.deskWrap?.releaseDesk()
                    print("My long pressed ends")
                    print("     I can initiate any action on end")
                }
            }, perform: { })
        }
    }
}


struct DownButton_Previews: PreviewProvider {
    static var previews: some View {
        DownButton(testHeight: .constant(23.0)).environmentObject(ZGoBluetoothController())
    }
}

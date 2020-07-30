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
    
    @State private var pressed: Bool = false
    @Binding var testHeight: Float
    
    var body: some View {
        Button(action: {
            print("Moving up")
        }) {
            // How the button looks like
            VStack {
                Image(systemName: "arrow.up.square")
                .resizable()
                .frame(width: 75, height: 75)
                
//                .onTapGesture {
//                    self.bt.deskWrap?.raiseDesk()
//                }
            
            }
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: CGFloat(25), pressing: { pressing in
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.pressed = pressing
                }
                if pressing {
                    self.bt.deskWrap?.raiseDesk()
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
// What to perform
//            self.bt.deskWrap?.raiseDesk()
//            if self.testHeight < 48.0 {
//                self.testHeight += 1.0
//                print("Moving up!")
//            } else {
//                print("Reached maximum height")
//            }

struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        UpButton(testHeight: .constant(23.0)).environmentObject(ZGoBluetoothController())
    }
}

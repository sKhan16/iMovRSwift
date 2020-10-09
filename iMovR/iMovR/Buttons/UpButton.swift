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
            Image(systemName: "chevron.up")
                .resizable()
                .frame(width: 100, height: 75)
                .foregroundColor(Color.white)
                
                .onLongPressGesture(minimumDuration: 7, maximumDistance: CGFloat(50), pressing: { pressing in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.pressed = pressing
                    }
                    if pressing {
                        self.bt.deskWrap?.raiseDesk()
                        print("My long press starts")
                        //print("     I can initiate any action on start")
                    } else {
                        self.bt.deskWrap?.releaseDesk()
                        print("My long press ends")
                        //print("     I can initiate any action on end")
                    }
                }, perform: {})
                
                .simultaneousGesture(
                    // sends additional command for case when desk is asleep
                    LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                        .onEnded() { _ in
                            self.bt.deskWrap?.raiseDesk()
                            print("simultaneous long press upButton")
                    }
                )
        }
        .padding()
    }
}

struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        UpButton(testHeight: .constant(23.0)).environmentObject(ZGoBluetoothController())
    }
}

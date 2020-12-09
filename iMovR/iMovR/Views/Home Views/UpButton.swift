//
//  UpButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct UpButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var pressed: Bool
    @Binding var testHeight: Float
    
    var body: some View {
        Button(action: {
            print("Moving up")
        }) {
            // How the button looks like
            Image(systemName: "chevron.up")
                .resizable()
                .frame(maxWidth: 90, minHeight: 70, idealHeight: 80, maxHeight: 80)
                .foregroundColor(Color.white)
                
                .onLongPressGesture(minimumDuration: 7, maximumDistance: CGFloat(50), pressing: { pressing in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.pressed = pressing
                    }
                    if pressing {
                        self.bt.zipdesk.raiseDesk()
                        //print("     I can initiate any action on start")
                    } else {
                        self.bt.zipdesk.releaseDesk()
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                            self.pressed = false
                            timer.invalidate()
                        }
                    }
                }, perform: {})
                
                .simultaneousGesture(
                    // sends additional command for case when desk is asleep
                    LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                        .onEnded() { _ in
                            self.bt.zipdesk.raiseDesk()
                    }
                )
        }
        .padding()
    }
}

struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            UpButton(pressed: .constant(false), testHeight: .constant(23))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

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
    @Binding var unpressedTimer: Timer?
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: "chevron.up")
            .resizable()
            .frame(maxWidth: 90, minHeight: 70, idealHeight: 80, maxHeight: 80)
            .foregroundColor(Color.white)
                
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat(50),
                pressing: { pressing in
                    if pressing {
                        self.pressed = true
                        self.unpressedTimer?.invalidate()
                        self.unpressedTimer = nil
                        self.bt.zipdesk.raiseDesk()
                        print("press UP")
                    }
                    else { // unpressed UpButton
                        self.bt.zipdesk.releaseDesk()
                        self.unpressedTimer = Timer.scheduledTimer (
                            withTimeInterval: 1.5,
                            repeats: false
                        ) { timer in
                            print("release UP -> timer")
                            self.pressed = false
                        }
                    }
                },
                perform: {}
            )
            
            .simultaneousGesture (
                // additional move command in case desk was asleep
                LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                    .onEnded() { _ in
                        self.bt.zipdesk.raiseDesk()
                }
            )
        }
        .padding()
        .animation(.easeInOut)
    }
}


struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            UpButton(pressed: .constant(false), unpressedTimer: .constant(nil))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

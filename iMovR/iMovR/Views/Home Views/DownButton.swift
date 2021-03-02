//
//  DownButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DownButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var pressed: Bool
    @Binding var unpressedTimer: Timer?
    @State private var animateColor: Color = Color.white
    @State private var animateBlur: CGFloat = CGFloat(0.0)
    @State private var animateOpacity: Double = 1.0
    
    var body: some View {
        Button(action: {}) {
            Image("DownButton")
                .resizable()
                .frame(maxWidth: 100, minHeight: 90, idealHeight: 100, maxHeight: 150)
                .foregroundColor(animateColor)
                .blur(radius: animateBlur)
                .opacity(animateOpacity)
                
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat(50),
                pressing: { pressing in
                    if pressing {
                        self.pressed = true
                        withAnimation(.easeOut(duration: 0.05)) {
                            //animateColor = Color.spaghetti
                            //animateBlur = 1
                            animateOpacity = 0.15
                        }
                        self.unpressedTimer?.invalidate()
                        self.unpressedTimer = nil
                        self.bt.zipdesk.lowerDesk()
                        print("press DOWN")
                    }
                    else { // unpressed DownButton
                        self.bt.zipdesk.releaseDesk()
                        withAnimation(.easeIn(duration: 0.20)) {
                            //animateBlur = 0.0
                            animateOpacity = 1.0
                        }
                        self.unpressedTimer = Timer.scheduledTimer (
                            withTimeInterval: 1.5,
                            repeats: false
                        ) { timer in
                            print("release DOWN -> timer")
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
                        self.bt.zipdesk.lowerDesk()
                }
            )
        }
        .padding(.trailing)
        
    }
}


struct DownButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            DownButton(pressed: .constant(false), unpressedTimer: .constant(nil))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

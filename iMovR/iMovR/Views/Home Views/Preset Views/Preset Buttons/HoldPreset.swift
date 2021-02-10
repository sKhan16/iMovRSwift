//
//  HoldPreset.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/20/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HoldPreset: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var presetHeight: Float
    
    @State private var pressed: Bool = false
    @State private var animateColor: Color = ColorManager.preset
    @State private var animateBlur: CGFloat = CGFloat(0.0)
    @State private var animateOpacity: Double = 1.0
    
    var body: some View {
        Button(action: {}) {
            
            ZStack {
                Circle()
                .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)

                Text(String(format: "%.1f", presetHeight))
                    .frame(minWidth: 70, idealWidth: 75, maxWidth: 75, minHeight: 70, idealHeight: 75, maxHeight: 75)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }//end ZStack
                .foregroundColor(animateColor)
                .blur(radius: animateBlur)
                .opacity(animateOpacity)
            
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat(50),
                pressing: { pressing in
                    self.pressed = pressing
                    if pressing { // press begun
                        self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                        withAnimation(.easeOut(duration: 0.05)) {
                            //animateColor = Color.spaghetti
                            //animateBlur = 1
                            animateOpacity = 0.15
                        }
                    }
                    else { // press has ended
                        self.bt.zipdesk.releaseDesk()
                        withAnimation(.easeIn(duration: 0.20)) {
                            //animateBlur = 0.0
                            animateOpacity = 1.0
                        }
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                            self.pressed = false
                            timer.invalidate()
                        }
                    }
                },
                perform: {}
            )
            .simultaneousGesture (
                // additional move command in case desk was asleep
                LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                    .onEnded() { _ in
                        self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                    }
            )
        }//end Button View 'Label'
    }//end Body
}

struct HoldPreset_Previews: PreviewProvider {
    static var previews: some View {
        HoldPreset(presetHeight: .constant(32.0))
    }
}

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
    
    var body: some View {
        Button(action: {}) {
            ZStack {
                Circle()
                .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
                .shadow(color: .black, radius: 3, x: 0, y: 4)
//                .onLongPressGesture( minimumDuration: 7, maximumDistance: CGFloat(50), pressing: { pressing in
//                    withAnimation(.easeInOut(duration: 1.0)) {
//                        self.pressed = pressing
//                    }
//                    if pressing {
//                        self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
//                        print("My long press starts")
//                        //print("     I can initiate any action on start")
//                    } else {
//                        self.bt.zipdesk.releaseDesk()
//                        print("My long press ends")
//                        //print("     I can initiate any action on end")
//                    }
//                }, perform: {} )
//                .simultaneousGesture(//sends later command in case desk was asleep
//                    LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
//                        .onEnded() { _ in
//                            self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
//                            print("simultaneous long press activated")
//                    }
//                )
                Text(String(format: "%.1f", presetHeight))
                    .frame(minWidth: 70, idealWidth: 75, maxWidth: 75, minHeight: 70, idealHeight: 75, maxHeight: 75)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }//end ZStack
            .foregroundColor(ColorManager.preset)
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat(50),
                pressing: { pressing in
                    self.pressed = pressing
                    if pressing { // press begun
                        self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                    }
                    else { // press has ended
                        self.bt.zipdesk.releaseDesk()
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

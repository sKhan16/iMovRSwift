//
//  LoadedPreset.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/12/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct TouchPreset: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var zipdeskUI: ZGoZipDeskController
    @Binding var presetHeight: Float
    
    @State private var pressed: Bool = false
    
    var body: some View {
        Button(action: {
//            self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
//            print("TouchPreset: timer start")
//
//            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
//                print("TouchPreset: timer triggered")
//                self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
//                timer.invalidate()
//            }
        }) {
            ZStack {
                Circle()
                    .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
                Text(String(format: "%.1f", presetHeight))
                    .frame(minWidth: 70, idealWidth: 75, maxWidth: 75, minHeight: 70, idealHeight: 75, maxHeight: 75)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
            .foregroundColor(ColorManager.preset)
        }//end Button view 'Label'
        .onLongPressGesture (
            minimumDuration: 15,
            maximumDistance: CGFloat(50),
            pressing: { pressing in
                self.pressed = pressing
                if pressing { // press begun
                    self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                    
                    // additional move command in case desk was asleep
                    _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                        self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                        timer.invalidate()
                    }
                }
            },
            perform: {}
        )
    }
        
struct LoadedPreset_Previews: PreviewProvider {
    static var previews: some View {
        TouchPreset(zipdeskUI: ZGoZipDeskController(), presetHeight: .constant(33.3))
    }
}
}


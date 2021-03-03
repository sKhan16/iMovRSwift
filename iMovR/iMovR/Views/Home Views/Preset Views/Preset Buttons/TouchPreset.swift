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
        
//    var Unpressed = Image("ButtonFlat")
//    var Pressed = Image("ButtonPressed")
//
//    @State private var PresetBG = false
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
                //Circle()
                PresetBG()
                Text(String(format: "%.1f", presetHeight))
                    .frame(width: 60, height: 60)
                    .font(.system(size: 26))
                    .foregroundColor(Color(UIColor.systemBlue))
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


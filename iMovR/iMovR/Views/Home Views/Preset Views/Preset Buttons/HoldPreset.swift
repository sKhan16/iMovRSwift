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
                Image("ButtonFlat")
                    .resizable()
                    .frame(minWidth: 85, idealWidth: 95, maxWidth: 95, minHeight: 85, idealHeight: 95, maxHeight: 95)

                Text(String(format: "%.1f", presetHeight))
                    .frame(width: 60, height: 60)
                    .font(.system(size: 26))
                    .foregroundColor(Color(UIColor.systemGreen))
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
        ZStack {
        Image("Background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
        HoldPreset(presetHeight: .constant(32.0))
        }
    }
}

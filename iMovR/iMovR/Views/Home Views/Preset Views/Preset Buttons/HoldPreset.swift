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
   
//    var Unpressed = Image("ButtonFlat")
//    var Pressed = Image("ButtonPressed")
//
//    @State private var PresetBG = false
    @State private var pressed: Bool = false
    var geoWidth: CGFloat
    
    var body: some View {
        Button(action: {
     
        }) {
            ZStack {
                PresetBG(geoWidth: geoWidth)
                Text(String(format: "%.1f", presetHeight))
                    .frame(
                        width: ((geoWidth - 60)/4.5),
                        height: ((geoWidth - 60)/4.5))
                    .font(.system(size: (geoWidth - 60)/12))
                    .foregroundColor(Color(UIColor.systemBlue))
            }//end ZStack
            .foregroundColor(ColorManager.preset)
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat((geoWidth - 60)/4),
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
                LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat((geoWidth - 60)/4))
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
            HoldPreset(presetHeight: .constant(32.0), geoWidth: CGFloat(300))//375//300//428
        }
    }
}

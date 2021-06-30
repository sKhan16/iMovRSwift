//
//  InactivePreset.swift
//  iMovR
//
//  Created by Shakeel Khan on 5/5/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct InactivePreset: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var zipdeskUI: ZGoZipDeskController
    @Binding var presetHeight: Float
    
    @Binding var showInactivePopup: Bool
        
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
            }
            .foregroundColor(ColorManager.preset)
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat((geoWidth - 60)/4),
                pressing: { pressing in
                    self.pressed = pressing
                    if pressing { // press begun
                        self.showInactivePopup = true
                        
                    }
                },
                perform: {}
            )
        }//end Button view 'Label'
    }
}
struct InactivePreset_Previews: PreviewProvider {
    static var previews: some View {
        InactivePreset(zipdeskUI: ZGoZipDeskController(), presetHeight: .constant(33.3),showInactivePopup: .constant(false), geoWidth: CGFloat(300))
    }
}

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
    
    @State private var pressed: Bool = false
    
    @Binding var name: String
    @Binding var presetHeight: Float
    //@State var name: String
    //@State var presetHeight: Float
    
    @Binding var isMoving: Bool
    
    //@State var tapped = false
    
    
    
    
    var body: some View {
        Button(action: {
            //self.moveToPreset()
            //print("Moved to \(self.presetVal)")

                print("TG moved")
            self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                print("Start Timer fired b4 interval")
                
            let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                    print("Start Timer fired after interval!")
                    self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                    timer.invalidate()
                }
            /// Timer to test the onChange method to see if the desk is moving or not. TEST
//            let movingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
//                    print("desk move Timer fired after interval!")
//                if self.isMoving {
//                    self.isMoving = false
//                }
//                timer.invalidate()
//                }
        }) {
            VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        //.stroke(Color.black, lineWidth: 3)
                        //.background(Circle().foregroundColor(ColorManager.preset))
                        .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
                    Text(String(format: "%.1f", presetHeight))
                        .frame(minWidth: 70, idealWidth: 75, maxWidth: 75, minHeight: 70, idealHeight: 75, maxHeight: 75)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                }
            }
            .foregroundColor(ColorManager.preset)
        }//end Button
        .onChange(of: zipdeskUI.deskHeight, perform: { value in
            self.isMoving = true
        })
        
    }
        
struct LoadedPreset_Previews: PreviewProvider {
    static var previews: some View {
        TouchPreset(zipdeskUI: ZGoZipDeskController(), name: .constant("test preset"), presetHeight: .constant(33.3), isMoving: .constant(false))
    }
}
}


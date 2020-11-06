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
    
    @State private var pressed: Bool = false
    
    @State var name: String
    @State var presetHeight: Float
    
    //@State var tapped = false
    
    //@Binding var presetName: String
    //@Binding var presetHeight: Float
    
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
}

    }
        
struct LoadedPreset_Previews: PreviewProvider {
    static var previews: some View {
        TouchPreset(name: "test", presetHeight: 33.3)
    }
}
}


//
//  HeightSlider.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightSlider: View {
    @EnvironmentObject var bt: DeviceBluetoothController
    //@Binding var testHeight: Float
    
    var body: some View {
    
      
        
        VStack {
            Text(String(format: "%.1f", self.bt.deskHeight))
                .rotationEffect(.degrees(90))
                .font(.largeTitle)
            Slider(value: self.$bt.deskHeight, in: self.bt.minHeight...self.bt.maxHeight, step: 1)
            }
            .rotationEffect(.degrees(270))
            .disabled(true)
        
    }
}

struct HeightSlider_Previews: PreviewProvider {
    static var previews: some View {
        HeightSlider().environmentObject(DeviceBluetoothController())
    }
}

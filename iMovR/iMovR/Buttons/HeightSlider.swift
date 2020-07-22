//
//  HeightSlider.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightSlider: View {
    @EnvironmentObject var bt: ZGoBluetoothController
    //@Binding var testHeight: Float
    
    var body: some View {
    
      
        
        VStack {
            Text(String(self.bt.currentHeight))
                .rotationEffect(.degrees(90))
            Slider(value: self.$bt.currentHeight, in: self.bt.minHeight...self.bt.maxHeight, step: 1)
            }
            .rotationEffect(.degrees(270))
            .disabled(true)
        
    }
}

struct HeightSlider_Previews: PreviewProvider {
    static var previews: some View {
        HeightSlider().environmentObject(ZGoBluetoothController())
    }
}

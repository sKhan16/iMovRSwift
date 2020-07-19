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
    @Binding var testHeight: Float
    
    var body: some View {
    
        VStack {
            Text(String(testHeight))
                .rotationEffect(.degrees(90))
                Slider(value: $testHeight, in: 23...48, step: 1)
                //Text("\(testHeight, specifier: "%.1f")")
            }//.padding()
            .rotationEffect(.degrees(270))
            //.disabled(true)
        
    }
}

struct HeightSlider_Previews: PreviewProvider {
    static var previews: some View {
        HeightSlider(testHeight: .constant(23.0)).environmentObject(ZGoBluetoothController())
    }
}

//
//  PresetBG.swift
//  iMovR
//
//  Created by Shakeel Khan on 3/2/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct PresetBG: View {
    
    var Unpressed = Image("ButtonFlatBG")
    var Pressed = Image("ButtonPressed")
    
    @State private var PresetBG = false
    
    var body: some View {
        (PresetBG ? Pressed : Unpressed)
            .resizable()
            .frame(minWidth: 85, idealWidth: 95, maxWidth: 95, minHeight: 85, idealHeight: 95, maxHeight: 95)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        PresetBG = true
                    })
                    .onEnded({ _ in
                        PresetBG = false
                    }))
    }
}

struct PresetBG_Previews: PreviewProvider {
    static var previews: some View {
        PresetBG()
    }
}

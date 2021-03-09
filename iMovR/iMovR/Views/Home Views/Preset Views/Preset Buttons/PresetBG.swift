//
//  PresetBG.swift
//  iMovR
//
//  Created by Shakeel Khan on 3/2/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct PresetBG: View {
    
    var Unpressed = Image("ButtonRoundDark")
    var Pressed = Image("ButtonRoundDarkBG")
    
    @State private var PresetBG = false
    
    var body: some View {
        (PresetBG ? Pressed : Unpressed)
            .resizable()
            .frame(minWidth: 75, idealWidth: 85, maxWidth: 85, minHeight: 75, idealHeight: 85, maxHeight: 85)
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

//
//  PresetBG.swift
//  iMovR
//
//  Created by Shakeel Khan on 3/2/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct PresetBG: View {
    
    var Unpressed = Image("shdwButtonUnpressed")
    var Pressed = Image("shdwButtonPressed")
    
    @State private var PresetBG = false
    
    var body: some View {
        (PresetBG ? Pressed : Unpressed)
            .resizable()
            .frame(minWidth: 85 + 15, idealWidth: 95 + 15, maxWidth: 95 + 15, minHeight: 85 + 15, idealHeight: 95 + 15, maxHeight: 95 + 15)
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

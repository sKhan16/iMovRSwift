//
//  PresetBG.swift
//  iMovR
//
//  Created by Shakeel Khan on 3/2/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct PresetBG: View {
    
    var Unpressed: Image
    var Pressed: Image
    var geoWidth: CGFloat
    private var size: CGFloat
    
    init (
        Unpressed: Image = Image("ButtonRoundDark"),
        Pressed: Image = Image("ButtonRoundDarkBG"),
        geoWidth: CGFloat
    )
    {
        self.Unpressed = Unpressed
        self.Pressed = Pressed
        self.geoWidth = geoWidth
        size = (geoWidth - 60)/4
    }
    
    @State private var PresetBG = false
    
    var body: some View {
        (PresetBG ? Pressed : Unpressed)
            .resizable()
            .frame(width: size, height: size)
            .gesture (
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        PresetBG = true
                    })
                    .onEnded({ _ in
                        PresetBG = false
                    })
            )
    }
}

struct PresetBG_Previews: PreviewProvider {
    static var previews: some View {
        PresetBG(geoWidth: CGFloat(300))
    }
}

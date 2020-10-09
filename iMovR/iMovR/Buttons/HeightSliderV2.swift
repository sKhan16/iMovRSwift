//
//  HeightSliderV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightSliderV2: View {
    @EnvironmentObject var bt: ZGoBluetoothController
    
    //curr - min / max - min
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                        Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                            .opacity(0.3)
                            .foregroundColor(Color.white)
                            
                        Rectangle().frame(width: min(CGFloat((self.bt.currentHeight - self.bt.minHeight) / (self.bt.maxHeight - self.bt.minHeight))*geometry.size.width, geometry.size.width), height: geometry.size.height)
                            .foregroundColor(Color(UIColor.systemGreen))
                            .animation(.linear)
                    }.cornerRadius(45.0)
            .rotationEffect(.degrees(90))
            
    }
}
}

struct HeightSliderV2_Previews: PreviewProvider {
    static var previews: some View {
        HeightSliderV2()
    }
}

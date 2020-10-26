//
//  HeightSliderV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightSliderV2: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    //curr - min / max - min
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(1.0)
                    .foregroundColor(Color.white)
                    
                Rectangle().frame(
                    width: geometry.size.width,
                    height: min( CGFloat(self.bt.zipdesk?.normalizedHeight ?? 0.5) * geometry.size.height, geometry.size.height )
                )
                    .foregroundColor(Color(UIColor.systemGreen))
                    .animation(.linear)
            }//end ZStack
            .cornerRadius(45.0)
            
        }//end GeoReader
    }//end body
}
/*
struct HeightSliderV2_Previews: PreviewProvider {
    @State var barPosition: Float = 0.7
    static var previews: some View {
        HeightSliderV2().frame(width: 20, height: 300)
            //.environmentObject(ZGoBluetoothController())
    }
}
 */

struct HeightSliderV2_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            HeightSliderV2()//this value doesnt matter unless we remove the BT height... default BTController returned height is 0.0/1
                .environmentObject(DeviceBluetoothManager())
                .frame(width: 20)// By default slider size is undefined
                .padding([.top,.bottom], 20)
        }
    }
}

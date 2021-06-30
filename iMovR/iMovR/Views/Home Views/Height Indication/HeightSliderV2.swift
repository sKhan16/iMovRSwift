//
//  HeightSliderV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightSliderV2: View {
    @ObservedObject var zipdeskUI: ZGoZipDeskController
    @ObservedObject var deviceData: DeviceDataManager
    @Binding var isPaged: Bool
    
    
    // position of slider:
    // (currHeight-minHeight)/(maxHeight-minHeight)
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .bottom) {
                
                // Height Slider main body
                HStack {
                    Spacer()
                    ZStack(alignment:.bottom) {
                        Rectangle()
                        .frame (
                            width: geometry.size.width ,
                            height: geometry.size.height
                        )
                            .opacity(1.0)
                            .foregroundColor(Color.white)
                            
                        Rectangle()
                        .frame (
                            width: geometry.size.width,
                            height: min ( CGFloat(self.zipdeskUI.normalizedHeight) * geometry.size.height, geometry.size.height
                            )
                        )
                            .foregroundColor(deviceData.connectedDeskIndex == deviceData.devicePickerIndex ? Color(UIColor.systemGreen) : Color(UIColor.systemRed))
                            .animation(Animation.linear(duration: 0.55))
                    }
                    .frame(idealWidth: 25, maxWidth: 25, maxHeight: .infinity)
                    .cornerRadius(25)
                    Spacer()
                }
                
                // HeightTickMark preset indicators
                if let deskIndex: Int = deviceData.connectedDeskIndex,
                let currDeskPresets = deviceData.savedDevices[deskIndex].presetHeights
                {
                    ForEach(0...5, id: \.self)
                    { index in
                        if (!isPaged && index <= 2) || (isPaged && index >= 3)
                        {
                            let normPresetH = CGFloat( (currDeskPresets[index]-zipdeskUI.minHeight)/(zipdeskUI.maxHeight-zipdeskUI.minHeight))
                            HeightTickMark (
                                height: Binding<Float>(
                                    get: { currDeskPresets[index] },
                                    set: { _ in } ) )
                                .offset(
                                x: 25,
                                y: 10 - min(normPresetH*geometry.size.height, geometry.size.height))
                        }
                    }
                }//end preset tick marks
                
            }//end top-level ZStack
            
        }//end GeoReader
        
    }//end body
}


struct HeightSliderV2_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            HeightSliderV2(zipdeskUI: ZGoZipDeskController(),
                           deviceData: DeviceDataManager(test:true)!, isPaged: .constant(false))
                .environmentObject(DeviceBluetoothManager())
                .frame(width: 50)// By default slider size is undefined
                .padding([.top,.bottom], 200)
        }
    }
}

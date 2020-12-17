//
//  PresetModule.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/12/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetModule: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var isPaged: Bool
    @Binding var showAddPreset: [Bool]
    @Binding var isTouchGo: Bool
    @Binding var showPresetPopup: Bool
    @Binding var isMoving: Bool
    var body: some View {
        HStack {
            if self.isPaged {//last 3 presets
                HStack {
                    PresetButton(data: bt.data, index: 3, showAddPreset: self.$showAddPreset[3], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                        .fixedSize()
                        .padding(.leading, 5)
                        .padding(.top, 10)
                }
                    .frame(maxHeight: .infinity, alignment: .top)
                
                VStack {
                    PresetEditButton(show: $showPresetPopup)
                        .padding(.bottom, 10)
                    HStack(alignment: .bottom) {
                        PresetButton(data: bt.data, index: 4, showAddPreset: self.$showAddPreset[4], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.trailing, 10)
                        PresetButton(data: bt.data, index: 5, showAddPreset: self.$showAddPreset[5], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.leading, 10)
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxHeight: .infinity)
                
            } else {// first 3 presets
                HStack {
                    PresetButton(data: bt.data, index: 0, showAddPreset: self.$showAddPreset[0], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                        .fixedSize()
                        .padding(.leading, 5)
                        .padding(.top, 10)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                VStack {
                    PresetEditButton(show: $showPresetPopup)
                        .padding(.bottom, 10)
                    HStack(alignment: .bottom) {
                        PresetButton(data: bt.data, index: 1, showAddPreset: self.$showAddPreset[1], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.trailing, 10)
                        PresetButton(data: bt.data, index: 2, showAddPreset: self.$showAddPreset[2], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.leading, 10)
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxHeight: .infinity)
                
            }//end of isPaged preset logic
            
            HStack {
                MorePresetButton(isPaged: self.$isPaged)
                    //.offset(y: -80)
                    .padding(.trailing, 5)
                    .padding(.top, 10)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
        }//end 1st-level HStack
        .frame(height: 190)
        .onAppear() { withAnimation(.easeIn(duration: 5),{}) }
        .onDisappear() { withAnimation(.easeOut(duration: 5),{}) }
        
    }//end body
}


struct PresetModule_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                PresetModule(
                    isPaged: .constant(false),
                    showAddPreset: .constant([Bool](repeating: false, count: 6)),
                    isTouchGo: .constant(true),
                    showPresetPopup: .constant(false),
                    isMoving: .constant(false)
                )
                .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 11")
            
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                PresetModule(
                    isPaged: .constant(false),
                    showAddPreset: .constant([Bool](repeating: false, count: 6)),
                    isTouchGo: .constant(true),
                    showPresetPopup: .constant(false),
                    isMoving: .constant(false)
                )
                .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewLayout(.device)
            .previewDevice("iPhone 6s")

        }
    }
}

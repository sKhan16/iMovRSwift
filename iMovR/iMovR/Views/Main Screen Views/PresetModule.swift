//
//  PresetModule.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/12/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetModule: View {

    @State var isPaged: Bool = false
    @Binding var showAddPreset: [Bool]
    @Binding var isTouchGo: Bool
    @Binding var showPresetPopup: Bool
    
    var body: some View {
        HStack {
            if self.isPaged {//last 3 presets
                HStack {
                    PresetButton(index: 3, showAddPreset: self.$showAddPreset[3], isTouchGo: self.$isTouchGo)
                        //.offset(y: -80)
                        .padding(.trailing, 5)
                        .padding(.top, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    PresetEditButton(show: $showPresetPopup)
                        .padding(.bottom, (self.isTouchGo ? 0.0 : 20.0))
                    if self.isTouchGo {
                        StopGoButton()
                    }
                    HStack(alignment: .bottom) {
                        PresetButton(index: 4, showAddPreset: self.$showAddPreset[4], isTouchGo: self.$isTouchGo)
                            .padding(.trailing, 10)
                        PresetButton(index: 5, showAddPreset: self.$showAddPreset[5], isTouchGo: self.$isTouchGo)
                            .padding(.leading, 10)
                    }
                }
                .frame(maxHeight: .infinity)
                
            } else {// first 3 presets
                HStack {
                    PresetButton(index: 0, showAddPreset: self.$showAddPreset[0], isTouchGo: self.$isTouchGo)
                    //.offset(y: -80)
                    .padding(.trailing, 5)
                    .padding(.top, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    PresetEditButton(show: $showPresetPopup)
                        .padding(.bottom, (self.isTouchGo ? 0.0 : 20.0))
                    if self.isTouchGo {
                        StopGoButton()
                    }
                    HStack(alignment: .bottom) {
                        PresetButton(index: 1, showAddPreset: self.$showAddPreset[1], isTouchGo: self.$isTouchGo)
                            .padding(.trailing, 10)
                        
                        PresetButton(index: 2, showAddPreset: self.$showAddPreset[2], isTouchGo: self.$isTouchGo)
                            .padding(.leading, 10)
                    }
                }
                .frame(maxHeight: .infinity)
            }
            HStack {
            MorePresetButton(isPaged: self.$isPaged)
                //.offset(y: -80)
                .padding(.leading, 5)
                .padding(.top, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }//end 1st-level HStack
        .frame(minHeight: 180, idealHeight: 180, maxHeight: 180)
    }//end body

}


struct PresetModule_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            PresetModule(
                isPaged: false,
                showAddPreset: .constant([Bool](repeating: false, count: 6)),
                isTouchGo: .constant(true),
                showPresetPopup: .constant(false)
            )
        }
    }
}

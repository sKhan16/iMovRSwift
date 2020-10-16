//
//  PresetModule.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/12/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetModule: View {
    @EnvironmentObject var user: UserObservable

    @State var isPaged: Bool = false
    @Binding var showAddPreset: [Bool]
    @Binding var isTouchGo: Bool
    
    var body: some View {
        HStack {
            if self.isPaged {//last 3 presets
                HStack {
                    PresetButton(index: 3, showAddPreset: self.$showAddPreset[3])
                        //.offset(y: -80)
                        .padding(.trailing, 5)
                        .padding(.top, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    PresetEditButton()
                    MovementButton(isTouchGo: self.$isTouchGo)
                    HStack(alignment: .bottom) {
                        PresetButton(index: 4, showAddPreset: self.$showAddPreset[4])
                            .padding(.trailing, 10)
                        PresetButton(index: 5, showAddPreset: self.$showAddPreset[5])
                            .padding(.leading, 10)
                    }
                }
            } else {// first 3 presets
                HStack {
                PresetButton(index: 0, showAddPreset: self.$showAddPreset[0])
                    //.offset(y: -80)
                    .padding(.trailing, 5)
                    .padding(.top, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    PresetEditButton()
                    MovementButton(isTouchGo: self.$isTouchGo)
                    HStack(alignment: .bottom) {
                        PresetButton(index: 1, showAddPreset: self.$showAddPreset[1])
                            .padding(.trailing, 10)
                        
                        PresetButton(index: 2, showAddPreset: self.$showAddPreset[2])
                            .padding(.leading, 10)
                    }
                }
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
                showAddPreset: .constant([Bool](repeating: true, count: 6)),
                isTouchGo: .constant(true)
            )
                .environmentObject(UserObservable())
        }
    }
}

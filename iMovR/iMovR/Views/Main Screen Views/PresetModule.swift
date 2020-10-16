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
        
        VStack {
            PresetEditButton()
            MovementButton(isTouchGo: self.$isTouchGo)
        HStack {
            if self.isPaged {
                
                PresetButton(index: 3, showAddPreset: self.$showAddPreset[3])
                    .offset(y: -80)
                    .padding(.top)
                
                PresetButton(index: 4, showAddPreset: self.$showAddPreset[4])
                    .padding(.trailing)
                
                PresetButton(index: 5, showAddPreset: self.$showAddPreset[5])

            } else {
                PresetButton(index: 0, showAddPreset: self.$showAddPreset[0])
                    .offset(y: -80)
                    .padding(.top)
                
                PresetButton(index: 1, showAddPreset: self.$showAddPreset[1])
                    .padding(.trailing)
                
                PresetButton(index: 2, showAddPreset: self.$showAddPreset[2])

                }
            MorePresetButton(isPaged: self.$isPaged)
                .offset(y: -80)
                .padding([.trailing, .top])
            }
        }
    }
    }

struct PresetModule_Previews: PreviewProvider {
    static var previews: some View {
        PresetModule(isPaged: false, showAddPreset: .constant([Bool](repeating: true, count: 6)), isTouchGo: .constant(true))
    }
}

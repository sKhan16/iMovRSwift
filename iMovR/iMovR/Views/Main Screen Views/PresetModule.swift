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
    
    var body: some View {
        HStack {
            if self.isPaged {
                
                PresetButton(index: 3, showAddPreset: self.$showAddPreset[3])
                    .offset(y: -80)
                    .padding(.top)
                
                PresetButton(index: 4, showAddPreset: self.$showAddPreset[4])
                    .padding(.trailing)
                
                PresetButton(index: 5, showAddPreset: self.$showAddPreset[5])
//                ForEach((0...2), id: \.self) { index in
//                    if self.user.testPresets[index] > -1 {
//                        LoadedPreset(name: "pset \(index)", presetVal: self.user.testPresets[index])
//                            .padding()
//                    } else {
//                    AddPresetButton(index: index, showAddPreset: self.$showAddPreset).padding()
//
//                    }
//                }
            } else {
                PresetButton(index: 0, showAddPreset: self.$showAddPreset[0])
                    .offset(y: -80)
                    .padding(.top)
                
                PresetButton(index: 1, showAddPreset: self.$showAddPreset[1])
                    .padding(.trailing)
                
                PresetButton(index: 2, showAddPreset: self.$showAddPreset[2])
//                    ForEach((3...5), id: \.self) { index in
//                        if self.user.testPresets[index] > -1 {
//                            LoadedPreset(name: "pset \(index)", presetVal: self.user.testPresets[index])
//                                .padding()
//                        } else {
//                            AddPresetButton(index: index, showAddPreset: self.$showAddPreset).padding()
//                        }
//                    }
                }
            MorePresetButton(isPaged: self.$isPaged)
                .offset(y: -80)
                .padding([.trailing, .top])
            }
//            AddPresetButton(index: 0, showAddPreset: self.$showAddPreset)
//            AddPresetButton(index: 1, showAddPreset: self.$showAddPreset)
//            AddPresetButton(index: 2, showAddPreset: self.$showAddPreset)
        }
    }

struct PresetModule_Previews: PreviewProvider {
    static var previews: some View {
        PresetModule(isPaged: false, showAddPreset: .constant([Bool](repeating: true, count: 6)))
    }
}

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
    @Binding var showPresetPopup: Bool
    @Binding var isMoving: Bool
    var body: some View {
        if self.isMoving {
            HStack {
                StopGoButton(isMoving: self.$isMoving)
            }
                .onAppear() { withAnimation(.easeIn(duration: 5),{}) }
                .onDisappear() { withAnimation(.easeOut(duration: 5),{}) }
        } else {
        HStack {
            if self.isPaged {//last 3 presets
                HStack {
                    PresetButton(index: 3, showAddPreset: self.$showAddPreset[3], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                        //.offset(y: -80)
                        .fixedSize()
                        .padding(.leading, 5)
                        .padding(.top, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    PresetEditButton(show: $showPresetPopup)
                        .padding(.bottom)
                    ///Change to self.isTouchGo for old functionality
                    if self.isMoving && self.isTouchGo {
                        StopGoButton(isMoving: self.$isMoving)
                    }
                    HStack(alignment: .bottom) {
                        PresetButton(index: 4, showAddPreset: self.$showAddPreset[4], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.trailing, 10)
                        PresetButton(index: 5, showAddPreset: self.$showAddPreset[5], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.leading, 10)
                    }
                }
                .frame(maxHeight: .infinity)
                
            } else {// first 3 presets
                HStack {
                    PresetButton(index: 0, showAddPreset: self.$showAddPreset[0], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                    //.offset(y: -80)
                        .fixedSize()
                        .padding(.leading, 5)
                        .padding(.top, 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    PresetEditButton(show: $showPresetPopup)
                        .padding(.bottom)
                    
                    ///Change THIS to self.isMoving to see the stop button appear when desk is moving. ELSE change to self.isTouchGo to see the button appear when in Touch and go mode
                    if self.isMoving {
                        StopGoButton(isMoving: self.$isMoving)
                    }
                    HStack(alignment: .bottom) {
                        PresetButton(index: 1, showAddPreset: self.$showAddPreset[1], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.trailing, 10)
                        PresetButton(index: 2, showAddPreset: self.$showAddPreset[2], isTouchGo: self.$isTouchGo, isMoving: self.$isMoving)
                            .fixedSize()
                            .padding(.leading, 10)
                    }
                }
                .frame(maxHeight: .infinity)
            }//end of isPaged preset logic
            HStack {
            MorePresetButton(isPaged: self.$isPaged)
                //.offset(y: -80)
                .padding(.trailing, 5)
                .padding(.top, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }//end 1st-level HStack
        .frame(height: 180)
        .onAppear() { withAnimation(.easeIn(duration: 5),{}) }
        .onDisappear() { withAnimation(.easeOut(duration: 5),{}) }
    }//end body
    }
}


struct PresetModule_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                PresetModule(
                    isPaged: false,
                    showAddPreset: .constant([Bool](repeating: false, count: 6)),
                    isTouchGo: .constant(true),
                    showPresetPopup: .constant(false), isMoving: .constant(false)
                )
                .environmentObject(UserObservable())
            }
            .previewDevice("iPhone 11")
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                PresetModule(
                    isPaged: false,
                    showAddPreset: .constant([Bool](repeating: false, count: 6)),
                    isTouchGo: .constant(true),
                    showPresetPopup: .constant(false), isMoving: .constant(false)
                )
                .environmentObject(UserObservable())
            }
            .previewLayout(.device)
            .previewDevice("iPhone 6s")
        }
    }
}

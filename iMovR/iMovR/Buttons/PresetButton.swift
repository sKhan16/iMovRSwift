//
//  PresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetButton: View {
    @EnvironmentObject var bt: ZGoBluetoothController
   @Environment(\.colorScheme) var colorScheme
    
   @State var name: String
   @State var presetVal: Float
    
    var body: some View {
        Button(action: {
            //self.moveToPreset()
            print("Moved to \(self.presetVal)")
        }) {
            VStack {
                Text(String(presetVal))
                
                    .padding(13)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    .padding(6)
                Text(name)
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .frame(width: 80, height: 50)
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged({ (touch) in
//                        self.bt.deskWrap?.moveToHeight(PresetHeight: self.presetVal)
//                        print("Preset \(self.presetVal) touchdown")
//                    })
//                    .onEnded({ (touch) in
//                        self.bt.deskWrap?.releaseDesk()
//                        print("Preset \(self.presetVal) released")
//                    })
//            )
        }
    }
}



struct PresetButton_Previews: PreviewProvider {
    static var previews: some View {
        PresetButton(name: "Sitting", presetVal: 32.2)
            .environmentObject(ZGoBluetoothController())
    }
}

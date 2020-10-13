//
//  LoadedPreset.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/12/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct LoadedPreset: View {
    
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @State private var pressed: Bool = false
    
    @State var name: String
    @State var presetVal: Float
    
    //@State var tapped = false
    
    //@Binding var presetName: String
    //@Binding var presetHeight: Float
    
    var body: some View {
        Button(action: {
            //self.moveToPreset()
            print("Moved to \(self.presetVal)")
            
            //self.presetName = self.name
            //self.presetHeight = self.presetVal
            
        }) {
            VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        //.stroke(Color.black, lineWidth: 3)
                        //.background(Circle().foregroundColor(ColorManager.preset))
                        .frame(width: 80.0, height: 80)
                    Text(String(format: "%.1f", presetVal))
                        .frame(width: 75, height: 75)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                }
            }
            .foregroundColor(ColorManager.preset)
}
    }
struct LoadedPreset_Previews: PreviewProvider {
    static var previews: some View {
        LoadedPreset(name: "test", presetVal: 33.3)
    }
}
}

//
//  EmptyPreset.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/12/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EmptyPreset: View {
    @EnvironmentObject var bt: ZGoBluetoothController

    @State private var pressed: Bool = false
    
    @State var name: String
    @State var presetVal: Float
    
    //@State var tapped = false
    
    @Binding var presetName: String
    @Binding var presetHeight: Float
    
    var body: some View {
        Button(action: {
            //self.moveToPreset()
            print("Moved to \(self.presetVal)")
            
            self.presetName = self.name
            self.presetHeight = self.presetVal
            
        }) {
            VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 45.0, height: 45)
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
        }
        .foregroundColor(ColorManager.preset)
        .frame(width: 200, height: 200)
}

struct EmptyPreset_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPreset(name: "test", presetVal: 33.3, presetName: .constant("test"), presetHeight: .constant(33.3)).environmentObject(ZGoBluetoothController())
    }
}
}

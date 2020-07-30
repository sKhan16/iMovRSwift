//
//  HoldButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/29/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HoldButton: View {
    
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @State private var pressed: Bool = false
    
    @Binding var presetName: String
    @Binding var presetHeight: Float
    
    var body: some View {
        //var formatHeight = String(format: "%.1f", self.$presetHeight)
        Text("move to: \(String(format: "%.1f", self.presetHeight))")
            .padding()
            .background(Color(red: 227/255, green: 230/255, blue: 232/255))
            .shadow(radius: 5)
            .foregroundColor(.black)
            .font(.title)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: CGFloat(25), pressing: { pressing in
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.pressed = pressing
                }
                if pressing {
                    self.bt.deskWrap?.moveToHeight(PresetHeight: self.presetHeight)
                    print("My long pressed starts")
                    print("     I can initiate any action on start")
                } else {
                    self.bt.deskWrap?.releaseDesk()
                    print("My long pressed ends")
                    print("     I can initiate any action on end")
                }
            }, perform: { })
    }
}

struct HoldButton_Previews: PreviewProvider {
    static var previews: some View {
        HoldButton(presetName: .constant("Sitting"), presetHeight: .constant(Float(32.2.rounded())))
    }
}

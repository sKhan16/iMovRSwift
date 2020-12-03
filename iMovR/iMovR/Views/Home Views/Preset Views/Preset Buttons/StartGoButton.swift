//
//  StartGoButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 9/11/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
import SwiftUI

struct StartGoButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var presetHeight: Float
    
    var body: some View {
        Button(action: {
            self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
            print("Start Timer fired b4 interval")
            let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                print("Start Timer fired after interval!")
                self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                timer.invalidate()
            }
        }) {
        Text("Start")
        .fontWeight(.bold)
        .font(.title)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
        .background(Color.green)
        .cornerRadius(40)
        .foregroundColor(.white)
        //.padding(10)
        /*.overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.purple, lineWidth: 0)
        )*/
        }
    }
}

struct StartGoButton_Previews: PreviewProvider {
    static var previews: some View {
        StartGoButton(presetHeight: .constant(32.0))
    }
}

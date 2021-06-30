//
//  DownButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DownButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    
    @Binding var pressed: Bool
    @Binding var unpressedTimer: Timer?
    @Binding var showInactivePopup: Bool
    
    var Unpressed = Image("DownButton")
    var Pressed = Image("DownButtonPressed")
    
    @State private var ButtonBG = false
    @State private var animateColor: Color = Color.white
    @State private var animateBlur: CGFloat = CGFloat(0.0)
    @State private var animateOpacity: Double = 1.0
    
    var body: some View {
        if (self.data.connectedDeskIndex == self.data.devicePickerIndex) && (self.data.connectedDeskIndex != nil) {
            DownButtonActive(pressed: self.$pressed, unpressedTimer: self.$unpressedTimer)
        } else {
            DownButtonInactive(pressed: self.$pressed, unpressedTimer: self.$unpressedTimer, showInactivePopup: self.$showInactivePopup)
        }
    }
}


struct DownButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            DownButton(data: DeviceDataManager(), pressed: .constant(false), unpressedTimer: .constant(nil), showInactivePopup: .constant(false))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

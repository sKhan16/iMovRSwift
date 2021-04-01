//
//  PickerDisplayView.swift
//  iMovR
//
//  Created by Michael Humphrey on 2/8/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct PickerDisplayView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    @Binding var isConnected: Bool
    
    
    @ViewBuilder
    var body: some View {
        if data.devicePickerIndex != nil,
           self.data.savedDevices.indices.contains(data.devicePickerIndex!)
        {
            Button (
                action: {
                    guard let pickerIndex: Int = data.devicePickerIndex
                    else { return }
                    let thisDevice: Desk = self.bt.data.savedDevices[pickerIndex]
                    if isConnected
                    { // Disconnect from this connected desk
                        _ = bt.disconnectFromDevice (
                            device: thisDevice,
                            savedIndex: pickerIndex )
                    }
                    else
                    {
                        _ = self.bt.connectToDevice (
                            device: thisDevice,
                            savedIndex: pickerIndex )
                    }
                }
            )
            { // button Label
                ZStack {
                    Text(data.savedDevices[self.data.devicePickerIndex!].name)
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .padding([.leading,.trailing], 35) //fix overlap in ZStack
                    
                    if self.data.connectedDeskIndex != nil,
                       self.data.connectedDeskIndex! == self.data.devicePickerIndex
                    {
                        Text("Connected")
                            .font(.system(size: 20))
                            // icky change. OG color: ColorManager.connectGreen
                            .foregroundColor(Color.white)
                            .offset(y: 30)
                    }
                    
                    else if self.data.savedDevices[self.data.devicePickerIndex!].peripheral != nil
                    {
                        if self.data.savedDevices[self.data.devicePickerIndex!].inRange
                        {
                            Text("Available")
                                .font(.system(size: 20))
                                // icky change. OG color: ColorManager.morePreset
                                .foregroundColor(Color.white)
                                .offset(y: 30)
                        }
                        else
                        {
                            Text("Weak Signal - Move Closer")
                                .font(.system(size: 20))
                                // icky change. OG color: ColorManager.morePreset
                                .foregroundColor(Color.white)
                                .offset(y: 30)
                        }
                    }
                    
                    else
                    {
                        Text("Not Found")
                            .font(.system(size: 20))
                            // icky change. OG color: ColorManager.morePreset
                            .foregroundColor(Color.white)
                            .offset(y: 30)
                    }
                }
            }
        }
        else
        {
            Text("Please Save A Device")
                .font(.system(size: 20))
                // icky change. OG color: ColorManager.morePreset
                .foregroundColor(Color.white)
                .offset(y: 30)
        }
        
    } //end body
}

struct PickerDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PickerDisplayView(data: DeviceDataManager(test: true)!, isConnected: .constant(true))
    }
}

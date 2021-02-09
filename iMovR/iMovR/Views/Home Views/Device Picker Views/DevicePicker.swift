//
//  DevicePicker.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI



struct DevicePicker: View {
    @ObservedObject var data: DeviceDataManager
    
    init(data: DeviceDataManager) {
        self.data = data
    }
    
    
    init?(testMode: Bool) {
        guard testMode else { return nil }
        let tempData = DeviceDataManager()
        tempData.savedDevices = [
            Desk(name:"Main Office Deskkkkkkkkk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: true),
            Desk(name:"Treadmill Home Office",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false),
            Desk(name:"Home Desk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false)
        ]
        self.data = tempData
    }
    
    
    var body: some View {
        ZStack {
            if self.data.savedDevices.count > 0,
               self.data.devicePickerIndex != nil
            {
                PickerDisplayView (
                    data: self.data,
                    isConnected: Binding<Bool>(
                        get: {
                            if let connected = self.data.connectedDeskIndex {
                                return (connected == self.data.devicePickerIndex)
                            } else { return false }
                        },
                        set: { _=$0 } // Read-Only Binding
                    )
                )
            }
            else
            {
                Text("Please save a device")
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .padding([.leading,.trailing], 35)
            }
            HStack {
                PickerLeft(data: data)
                    .frame(width: 35)
                    .padding(.leading, 5)
                Spacer()
                PickerRight(data: data)
                    .frame(width: 35)
                    .padding(.trailing, 5)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 80, idealHeight: 80, maxHeight: 80)
        .background(ColorManager.deviceBG)
        .cornerRadius(75/2.0)
        .shadow(color: .black, radius: 3, x: 0, y: 4)
        .padding(.bottom, 10)
        .padding([.leading,.trailing], 5)
    }
    
}



struct PickerLeft: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    
    
    var body: some View {
        Button (
            action: {
                bt.scanForDevices()
                data.setPickerIndex(decrement: true)
            }
        ){
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                //.frame(width: 25)
        }
    }
}

struct PickerRight: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    
    var body: some View {
        Button (
            action: {
                bt.scanForDevices()
                data.setPickerIndex(increment: true)
            }
        ){
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                //.frame(width: 25)
        }
    }
}



struct DevicePicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            VStack {
                DevicePicker(testMode: true)
                    .padding(.top, 50)
                Spacer()
            }
        }
    }
}

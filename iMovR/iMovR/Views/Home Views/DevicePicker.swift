//
//  DevicePicker.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI



struct DevicePicker: View {
    @State private var index: Int = 0
    @ObservedObject var deviceData: DeviceDataManager
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    
    init(deviceData: DeviceDataManager) {
        self.deviceData = deviceData
    }
    
    // Only used for canvas preview mode
    init?(testMode: Bool) {
        guard testMode else { return nil }
        let tempData = DeviceDataManager()
        tempData.savedDevices =
            [ Desk(name:"Main Office Desk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""]),
              Desk(name:"Treadmill Home Office",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""]),
              Desk(name:"Home Desk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""]) ]
        self.deviceData = tempData
    }
    
    
    var body: some View {
        
        // used by DevicePicker to change the connected device-
        // -and update the local display index
        let autoconnectBinding = Binding<Int> (
            get: {
                return self.index
            },
            set: { newValue in
                self.index = newValue
                let connected: Int? = self.deviceData.connectedDeskIndex
                let devices: [Desk] = self.deviceData.savedDevices
                if connected == nil {
                    //                    var autoconnectDevices: [Desk] = []
                    //                    for device in devices {
                    //                        if device.peripheral != nil {
                    //                            bt.connectToDevice(device: <#T##Desk#>, savedIndex: <#T##Int#>)
                    //                        }
                    //                    }
                }
                else if connected == self.index {
                    if devices[connected!].peripheral?.state != .connected {
                        print("DevicePicker connecting to device")
                        guard bt.connectToDevice(device: devices[connected!], savedIndex: connected!) else {
                            print("DevicePicker ")
                        }
                    }
                }
                else if self.index != connected { // connect to the newly selected device
                    print("DevicePicker connecting to device")
                    guard bt.connectToDevice(device: devices[self.index], savedIndex: self.index) else {
                        print("DevicePicker ")
                    }
                }
            }//end set
        )//end binding
        
        
            HStack {
                PickerLeft(index: autoconnectBinding, devices: $deviceData.savedDevices)
                    .frame(width: 50, height: 80)
                Spacer()
                
                if deviceData.savedDevices.count > 0 {
                    ZStack {
                        Text(deviceData.savedDevices[self.index].name)
                            .font(.system(size: 40))
                            .foregroundColor(Color.white)
                            .offset(y: -5)
                        
                        if self.deviceData.connectedDeskIndex != nil,
                           self.deviceData.connectedDeskIndex! == self.index {
                            Text("Connected")
                                .font(Font.callout.weight(.regular))
                                .foregroundColor(ColorManager.preset)
                                .offset(y: 23)
                        } else {
                            Text("Disconnected")
                                .font(Font.callout.weight(.regular))
                                .foregroundColor(ColorManager.morePreset)
                                .offset(y: 23)
                        }
                    }
                }
                
                Spacer()
                PickerRight(index: autoconnectBinding, devices: $deviceData.savedDevices)
                    .frame(width: 50, height: 80)
            }
            .frame(maxWidth: .infinity, minHeight: 80, idealHeight: 80, maxHeight: 80)
    }
}

struct PickerLeft: View {
    @Binding var index: Int
    @Binding var devices: Array<Desk>
    
    var body: some View {
        Button(action: {
            if devices.count > 0 {
                if index == 0 {
                    index = devices.count - 1
                } else {
                    index -= 1
                }
            }
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                .frame(width: 25)
        }
    }
}

struct PickerRight: View {
    @Binding var index: Int
    @Binding var devices: Array<Desk>
    
    var body: some View {
        Button(action: {
            if devices.count > 0 {
                if index == devices.count - 1 {
                    index = 0
                } else {
                    index += 1
                }
            }
        }) {
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                .frame(width: 25)
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

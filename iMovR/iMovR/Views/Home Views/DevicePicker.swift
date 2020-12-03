//
//  DevicePicker.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI



struct DevicePicker: View {
    @State var index: Int = 0
    @ObservedObject var deviceData: DeviceDataManager
    
    
    init(deviceData: DeviceDataManager) {
        self.deviceData = deviceData
    }
    
    // Only used for canvas preview mode
    init?(testMode: Bool) {
        guard testMode else {
            return nil
        }
        let tempData = DeviceDataManager()
        tempData.savedDevices =
            [ Desk(name:"Main Office Desk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""]),
              Desk(name:"Treadmill Home Office",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""]),
              Desk(name:"Home Desk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""]) ]
        self.deviceData = tempData
    }
    
    var body: some View {
            HStack {
                PickerLeft(index: $index, devices: $deviceData.savedDevices)
                    .frame(width: 50, height: 80)
                Spacer()
                ZStack {
                    if deviceData.savedDevices.count > 0 {
                        Text(deviceData.savedDevices[index].name)
                            .font(.system(size: 40))
                            .foregroundColor(Color.white)
                    }
                }
                Spacer()
                PickerRight(index: $index, devices: $deviceData.savedDevices)
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
            DevicePicker(testMode: true)
        }
    }
}

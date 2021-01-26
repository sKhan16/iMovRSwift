//
//  DevicePicker.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI



struct DevicePicker: View {
    @ObservedObject var deviceData: DeviceDataManager
    @Binding var pickerIndex: Int?
    
    
    init(deviceData: DeviceDataManager) {
        self.deviceData = deviceData
    }
    
    init?(testMode: Bool) {
        guard testMode else { return nil }
        let tempData = DeviceDataManager()
        tempData.savedDevices = [
            Desk(name:"Main Office Deskkkkkkkkk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: true),
            Desk(name:"Treadmill Home Office",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false),
            Desk(name:"Home Desk",deskID:10009810, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false)
        ]
        self.deviceData = tempData
    }
    
    
    var body: some View {
        ZStack {
            
            HStack {
                PickerLeft(index: $pickerIndex, devices: $deviceData.savedDevices)
                    .frame(width: 35, height: 80)
                Spacer()
                PickerRight(index: $pickerIndex, devices: $deviceData.savedDevices)
                    .frame(width: 35, height: 80)
            }
            
            if self.deviceData.savedDevices.count > 0,
               self.pickerIndex != nil
            {
                ZStack {
                    Text(deviceData.savedDevices[self.pickerIndex!].name)
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .padding([.leading,.trailing], 35)
                    
                    if self.deviceData.connectedDeskIndex != nil,
                       self.deviceData.connectedDeskIndex! == self.pickerIndex! {
                        Text("Connected")
                            .font(Font.title2)
                            .foregroundColor(
                                Color(red: 0.3, green: 0.9, blue: 0.3)
                            )
                            .offset(y: 35)
                    } else {
                        Text("Disconnected")
                            .font(Font.title2)
                            .foregroundColor(ColorManager.morePreset)
                            .offset(y: 35)
                    }
                }
            } else {
                
                Text("Connect To A Device")
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                    .padding([.leading,.trailing], 35)
            }
            
        }
        .frame(maxWidth: .infinity, minHeight: 80, idealHeight: 80, maxHeight: 80)
        .padding(.bottom, 10)
    }
}


struct PickerLeft: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var index: Int?
    @Binding var devices: Array<Desk>
    
    var body: some View {
        Button(action: {
            self.bt.scanForDevices()
            if devices.count > 0 {
                if index == 0 {
                    index = devices.count - 1
                } else {
                    // CHANGE TO WORK WITH pickerIndex OPTIONAL
                    index -= 1
                }
            }
        }) {
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
    
    @Binding var index: Int?
    @Binding var devices: Array<Desk>
    
    var body: some View {
        Button(action: {
            self.bt.scanForDevices()
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
                //.frame(width: 25)
        }
    }
    
    func pickNextDeviceIndex(index: Int, reverse: Bool = false) -> Int {
        //recursive
        let savedCount = devices.count

        if index <= savedCount {
            if devices[index].peripheral != nil {
                return index
            } else {
                return pickNextDeviceIndex(index: (index + 1))
            }
        }
//        else if currIndex > savedCount {
//            return pickNextDeviceIndex(currIndex: 0)
//        }
        
        if let nextIndex: Int = devices.firstIndex (
        where: { (getidDevice) -> Bool in
        getidDevice.id == device.id }
        ) {
            return nextIndex
        } else {
            return pickNextDeviceIndex(currIndex: 0)
        }
        
        //return nextIndex
    }
}



func pickPreviousDeviceIndex(currIndex: Int) -> Int {
    return pickNextDeviceIndex(currIndex: currIndex, reverse: true)
}

//in range --- device.peripheral != nil

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

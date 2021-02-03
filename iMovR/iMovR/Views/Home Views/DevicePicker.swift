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
    @Binding var pickerIndex: Int?
    
    
    init(data: DeviceDataManager, pickerIndex: Binding<Int?>) {
        self.data = data
        self._pickerIndex = pickerIndex
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
        self._pickerIndex = Binding<Int?> (
            get: { return 0 },
            set: { $0 }
        )
    }
    
    
    var body: some View {
        let indexBinding = Binding<Int?> (
            get: {
                if self.pickerIndex == nil,
                   data.connectedDeskIndex != nil {
                    return data.connectedDeskIndex
                }
                return self.pickerIndex
            },
            set: {
                guard let nextIndex: Int = $0 else {
                    return
                }
                self.pickerIndex = pickAvailableDevice(nextIndex: nextIndex)
            }
        )
        
        ZStack {
            HStack {
                PickerLeft(index: indexBinding)
                    .frame(width: 35, height: 80)
                Spacer()
                PickerRight(index: indexBinding)
                    .frame(width: 35, height: 80)
            }
            
            if self.data.savedDevices.count > 0,
               self.pickerIndex != nil
            {
                ZStack {
                    Text(data.savedDevices[self.pickerIndex!].name)
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .padding([.leading,.trailing], 35)
                    
                    if self.data.connectedDeskIndex != nil,
                       self.data.connectedDeskIndex! == self.pickerIndex {
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
    
    
    func pickAvailableDevice(nextIndex: Int) -> Int? {
        
        let deviceCount = data.savedDevices.count
        guard deviceCount > 0 else { return nil }
        
        let filteredIndices = data.savedDevices.indices.filter {
            data.savedDevices[$0].peripheral != nil
        }
        guard filteredIndices.count > 0 else {return nil}
        
        if self.pickerIndex == nil {
            return filteredIndices[0]
//maybe instead loop and see if a device is currently connected??
        }
        else {
            let direction = (nextIndex - self.pickerIndex!) > 0
            for availableIndex in ( direction ? filteredIndices : filteredIndices.reversed() ) {
                
                if direction,
                   availableIndex > self.pickerIndex! {
                    return availableIndex
                }
                else if !direction,
                        availableIndex < self.pickerIndex! {
                    return availableIndex
                }
            }
            print("DevicePicker did not find another available device")
            return self.pickerIndex
        }
    }
    
}



struct PickerLeft: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var index: Int?
    
    var body: some View {
        Button (
            action: {
                self.bt.scanForDevices()
                if index != nil {
                    index! -= 1
                } else if bt.data.connectedDeskIndex != nil {
                    index = bt.data.connectedDeskIndex
                }
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
    @Binding var index: Int?
    
    var body: some View {
        Button (
            action: {
                self.bt.scanForDevices()
                if index != nil {
                    index! += 1
                } else if bt.data.connectedDeskIndex != nil {
                    index = bt.data.connectedDeskIndex
                }
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

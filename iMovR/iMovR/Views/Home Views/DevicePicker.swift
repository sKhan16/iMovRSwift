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
        let indexBinding = Binding<Int?> (
            get: { return self.data.devicePickerIndex },
            set: {
                if $0 == nil {
                    self.data.devicePickerIndex = nil
                }
                else {
                    self.data.devicePickerIndex = pickAvailableDevice(nextIndex: $0!)
                }
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
               self.data.devicePickerIndex != nil
            {
                ZStack {
                    Text(data.savedDevices[self.data.devicePickerIndex!].name)
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .padding([.leading,.trailing], 35)
                    
                    if self.data.connectedDeskIndex != nil,
                       self.data.connectedDeskIndex! == self.data.devicePickerIndex {
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
        .onChange(of: data.connectedDeskIndex, perform: { connectedDeskIndex in
            self.data.devicePickerIndex = connectedDeskIndex
        })
        .onChange(of: data.)
    }
    
    
    
    func pickAvailableDevice(nextIndex: Int) -> Int? {
        // Check saved devices count
        let deviceCount = data.savedDevices.count
        guard deviceCount > 0 else { return nil }
        
        // Check available devices count
        let filteredIndices = data.savedDevices.indices.filter {
            data.savedDevices[$0].peripheral != nil
        }
        guard filteredIndices.count > 0 else { return nil }
        
// MARK: ATTEMPTED WRAP CHECK PROBABLY WONT FIX THE FOR LOOP
        let nextIndexWrapped: Int
        if nextIndex > deviceCount - 1 { nextIndexWrapped = 0 }
        else if nextIndex < 0 { nextIndexWrapped = deviceCount - 1 }
        else { nextIndexWrapped = nextIndex }
        
        // Return the closest available index to nextIndex
        if self.data.devicePickerIndex == nil {
            return filteredIndices[0]
        }
        else {
            // Determine direction increasing/decreasing, and pick closest available index
//MARK: BUG - THIS DOESN'T WRAP UPON REACHING THE EDGE OF AVAILABLE DEVICES
            let direction = (nextIndex - self.data.devicePickerIndex!) > 0
            for availableIndex in (direction ? filteredIndices : filteredIndices.reversed()) {
                
                if direction,
                   availableIndex > self.data.devicePickerIndex! {
                    return availableIndex
                }
                else if !direction,
                        availableIndex < self.data.devicePickerIndex! {
                    return availableIndex
                }
            }
            print("DevicePicker did not find another available device")
            return self.data.devicePickerIndex
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

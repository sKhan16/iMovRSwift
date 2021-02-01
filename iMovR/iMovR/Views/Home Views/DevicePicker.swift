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
            get: { return 0},
            set: { $0 }
        )
    }
    
    
    var body: some View {
        let indexBinding = Binding<Int?> (
            get: { return self.pickerIndex },
            set: {
                guard let nextIndex: Int = $0 else {
                    return
                }
                if data.savedDevices.count > 0,
                   self.pickerIndex != nil {
//                   ************************
                    //pickNextDeviceIndex(index: self.pickerIndex, reverse: ((nextIndex - self.pickerIndex) > 0)
                    /*
                     ************************
                   ##above is replacing below##
                     ************************
                    if index == data.savedDevices.count - 1 {
                        index = 0
                    } else {
                        index += 1
                    }
                     ************************
                     */
                }
            }
        )
        // needs to do the following -->
        // get: return either the connectedDeskIndex or the available desk that the user wants to connect to. what about setting on startup/first connection? hmm
        // set: keep track of displayed device with devicePickerIndex and attempt to connect to said device. check if index has changed, and adjust it accordingly to go to the next AVAILABLE device, not just every saved device.
        
        
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
    /*
    func pickNextDeviceIndex(index: Int, reverse: Bool = false) -> Int {
        //recursive ugh (what if there are 3 unavailable devices between two ones in range?)
     
        let savedCount = data.savedDevices.count
        
        if index <= savedCount {
            if data.savedDevices[index].peripheral != nil {
                return index
            } else {
                return pickNextDeviceIndex(index: (index + 1))
            }
        }
        //        else if currIndex > savedCount {
        //            return pickNextDeviceIndex(currIndex: 0)
        //        }
        
        if let nextIndex: Int = data.savedDevices.firstIndex (
            where: { (getidDevice) -> Bool in
                getidDevice.id == device.id }
        ) {
            return nextIndex
        } else {
            return pickNextDeviceIndex(currIndex: 0)
        }
        
        //return nextIndex
    }
    
    public func pickPreviousDeviceIndex(currIndex: Int) -> Int {
        return pickNextDeviceIndex(currIndex: currIndex, reverse: true)
    }
     */

    
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

//
//  DeviceManagerView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

//use z stack popup stuff to get edit device menu(s)


struct DeviceManagerView: View {
  
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    
    @State var editDeviceIndex: Int = -1
    @State var saveDeviceIndex: Int = -1
    @State private var popupBackgroundBlur: CGFloat = 0
    
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Text("Device Manager")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(Color.white)
                    .padding()
                ScrollView {
                    
                    VStack {
                        Text("SAVED")
                            .foregroundColor(Color.white)
                            .font(Font.title2)
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 8)
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 2)
                    }
                    
                    ForEach(data.savedDevices, id:\.self.id) { device -> SavedDeviceRowView? in
                        guard let index: Int = data.savedDevices.firstIndex(
                                where: { (getidDevice) -> Bool in
                                    getidDevice.id == device.id
                                }) else {
                            return nil// device not found even though should be in array
                        }

                        //let isConnected: Binding<Bool> = (bt.connectedDeskIndex == index)
                        return SavedDeviceRowView (
                            data: self.data,
                            edit: $editDeviceIndex,
                            isConnected: Binding<Bool>(
                                get: {
                                    if let connected = self.data.connectedDeskIndex {
                                        return (connected == index)
                                    } else { return false }
                                },
                                set: { $0 } // Read-Only Binding
                            ),
                            deviceIndex: index
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("DISCOVERED")
                            .foregroundColor(Color.white)
                            .font(Font.title2)
                            .padding([.leading], 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 8)
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 2)
                    }
                    
                    ForEach(bt.discoveredDevices, id:\.self.id) { device -> DiscoveredDeviceRowView? in
                        guard let index: Int = bt.discoveredDevices.firstIndex(
                                                where: { (getidDevice) -> Bool in
                                                    getidDevice.id == device.id
                                                }) else {
                            return nil
                        }
                        return DiscoveredDeviceRowView(save: $saveDeviceIndex, deviceIndex: index)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(2)

                
            }//end VStack
            .blur(radius: popupBackgroundBlur)
            
            // pop up for editing saved device properties
            if (editDeviceIndex != -1) {
                EditDeviceView(deviceIndex: $editDeviceIndex, selectedDevice: self.data.savedDevices[editDeviceIndex])
                    .onAppear() {
                        self.popupBackgroundBlur = 5
                        withAnimation(.easeIn(duration: 5),{})
                    }
                    .onDisappear() {
                        self.popupBackgroundBlur = 0
                        withAnimation(.easeOut(duration: 5),{})
                    }
            // pop up for saving a new discovered device
            } else if (saveDeviceIndex != -1) {
                SaveDeviceView(deviceIndex: $saveDeviceIndex, selectedDevice: self.bt.discoveredDevices[saveDeviceIndex])
                    .onAppear() {
                        self.popupBackgroundBlur = 5
                        withAnimation(.easeIn(duration: 5),{})
                    }
                    .onDisappear() {
                        self.popupBackgroundBlur = 0
                        withAnimation(.easeOut(duration: 5),{})
                    }
            }
        }/*end ZStack*/.onAppear() {
            withAnimation(.easeInOut(duration: 10),{})
        }
        //.animation(.easeInOut)
    } //end Body
}

struct DeviceManagerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                DeviceManagerView(data: DeviceDataManager())
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 11")
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                
                DeviceManagerView(data: DeviceDataManager())
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 6s")
        }
    }
}

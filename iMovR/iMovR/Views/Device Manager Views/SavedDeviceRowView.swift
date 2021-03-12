//
//  SavedDeviceRowView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/26/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct SavedDeviceRowView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    @Binding var edit: Int
    @Binding var isConnected: Bool
    let deviceIndex: Int
    
    let testSavedDevices: [Desk] = [
        Desk(name: "Main Office Desk", deskID: 10009810, presetHeights:[], presetNames: [], isLastConnected: true),
        Desk(name: "Treadmill Home Office ", deskID: 54810, presetHeights:[], presetNames: [], isLastConnected: false),
        Desk(name: "Home Desk", deskID: 56781234, presetHeights:[], presetNames: [], isLastConnected: false)
    ]
    
    @ViewBuilder
    var body: some View {
        
        if !self.data.savedDevices.indices.contains(deviceIndex) {
            EmptyView()
            
        } else {
            let currDevice = self.data.savedDevices[deviceIndex]
            
            HStack {
                
                ConnectButton( deviceIndex: self.deviceIndex,
                               isConnected: self.$isConnected
                )
                    .frame(width:55, height:55)
                .padding([.leading,.trailing], 2)
                
                VStack {
                    /// Device Name and Status
                    if !bt.bluetoothEnabled {
                        Text(currDevice.name)
                            .font(.system(size: 20)).bold()
                            .truncationMode(.tail)
                            .foregroundColor(Color.gray)
                        Text("Phone Bluetooth Disabled")
                            .font(Font.body)
                            .foregroundColor(Color.gray)
                    }
                    else if self.isConnected {
                        Text(currDevice.name)
                            .font(.system(size: 20)).bold()
                            .truncationMode(.tail)
                            .foregroundColor(ColorManager.buttonPressed)
                        Text("Connected")
                            .font(Font.body.weight(.medium))
                            .foregroundColor(ColorManager.connectGreen)
                    }
                    else if self.data.savedDevices[deviceIndex].peripheral != nil {
                        Text(currDevice.name)
                            .font(.system(size: 20)).bold()
                            .truncationMode(.tail)
                            .foregroundColor(ColorManager.buttonPressed)
                        Text("Available")
                            .font(Font.body.weight(.medium))
                            .foregroundColor(ColorManager.buttonPressed)
                    }
                    else {
                        Text(currDevice.name)
                            .font(.system(size: 20)).bold()
                            .truncationMode(.tail)
                            .foregroundColor(Color.gray)
                        Text("Not Found Nearby")
                            .font(Font.body.weight(.medium))
                            .foregroundColor(Color.gray)
                    }
                }
                    .lineLimit(1)
                    .frame(idealWidth: .infinity, maxWidth: .infinity)
                
                EditButton(deviceIndex: self.deviceIndex, editIndex: $edit)
                    .frame(width:55, height:55)
                    .padding([.leading,.trailing], 2)
            }
            .frame(idealWidth: .infinity, maxWidth: .infinity, idealHeight: 60, maxHeight: 60)
            .background(
                Color(red: 0.97, green: 0.97, blue: 0.97)
                    .cornerRadius(60)
            )
            .padding([.leading, .trailing, .bottom], 2)
        }
    }// end Body
}// end SavedDeviceRowView



private struct ConnectButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    let deviceIndex: Int
    @Binding var isConnected: Bool
    
    var Unpressed: Image = Image("ButtonRoundDark")
    var Pressed: Image = Image("ButtonRoundDarkBG")
    @State private var isPressed: Bool = false
    
    @ViewBuilder
    var body: some View {
        
        if !self.bt.data.savedDevices.indices.contains(deviceIndex)
        {
            EmptyView()
        }
        else
        {
            ZStack {
                (isPressed ? Pressed : Unpressed)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 55, height: 55)
                
                if bt.bluetoothEnabled,
                   bt.data.savedDevices.indices.contains(deviceIndex),
                   bt.data.savedDevices[deviceIndex].peripheral != nil
                {
                    //this desk is saved and available
                    if isConnected
                    {
                        Image("ConnectCheckMark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                    }
                    else
                    {
                        Image("ConnectBlue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                    }
                }
                else
                {
                    //this desk is not available
                    Image("ConnectBlue")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .grayscale(1.0)//grayed out
                        .opacity(0.6)
                }
            }
            .gesture (
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        isPressed = true
                        let thisDevice: Desk = self.bt.data.savedDevices[deviceIndex]
                        
                        if isConnected
                        {
                            _ = bt.disconnectFromDevice(device: thisDevice, savedIndex: deviceIndex)
                        }
                        else
                        {
                            _ = self.bt.connectToDevice (
                                device: thisDevice,
                                savedIndex: deviceIndex
                            )
                        }
                    })
                    .onEnded({ _ in
                        isPressed = false
                    })
            )
        }
    }//end body
}//end ConnectButton


private struct EditButton: View {
    let deviceIndex: Int
    @Binding var editIndex: Int
    
    var Unpressed: Image = Image("ButtonRoundDark")
    var Pressed: Image = Image("ButtonRoundDarkBG")
    @State private var isPressed: Bool = false
    
    var body: some View {
        ZStack {
            (isPressed ? Pressed : Unpressed)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
            Image("EditIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
        }
        .gesture (
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    isPressed = true
                    print("edit device menu activated")
                    self.editIndex = self.deviceIndex
                })
                .onEnded({ _ in
                    isPressed = false
                })
        )
    }//end body
}//end EditButton

struct SavedDeviceRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                SavedDeviceRowView (
                    data: DeviceDataManager(test: true)!,
                    edit: .constant(0),
                    isConnected: .constant(true),
                    deviceIndex: 0
                )
                .environmentObject(
                    DeviceBluetoothManager(previewMode: true)!
                )
            }
            .previewDevice("iPhone 12")

//            ZStack {
//                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
//                SavedDeviceRowView (
//                    data: DeviceDataManager(test: true)!,
//                    edit: .constant(0),
//                    isConnected: .constant(true),
//                    deviceIndex: 0
//                )
//                .environmentObject(
//                    DeviceBluetoothManager(previewMode: true)!
//                )
//            }
//            .previewDevice("iPhone 6s")
        }
    }
}


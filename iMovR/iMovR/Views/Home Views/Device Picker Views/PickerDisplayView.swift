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
                    let pickerIndex: Int = data.devicePickerIndex!
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
                       self.data.connectedDeskIndex! == self.data.devicePickerIndex {
                        Text("Connected")
                            .font(.system(size: 20))
                            // icky change. OG color: ColorManager.connectGreen
                            .foregroundColor(Color.white)
                            .offset(y: 30)
                    } else {
                        Text("Available")
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
            EmptyView()
        }
        
    } //end body
}

struct PickerDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PickerDisplayView(data: DeviceDataManager(test: true)!, isConnected: .constant(true))
    }
}

/*
private struct ConnectButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    let deviceIndex: Int
    @Binding var isConnected: Bool
    
    @ViewBuilder
    var body: some View {
        
        if !self.bt.data.savedDevices.indices.contains(deviceIndex) {
            EmptyView()
        } else {
            Button( action: {
                let thisDevice: Desk = self.bt.data.savedDevices[deviceIndex]
                if isConnected { // Disconnect from this connected desk
                    _ = bt.disconnectFromDevice(device: thisDevice, savedIndex: deviceIndex)
                }
                else {
                    _ = self.bt.connectToDevice (
                        device: thisDevice,
                        savedIndex: deviceIndex
                    )
                }
                //            // No devices connected yet, connect normally
                //            else if bt.data.connectedDeskIndex == nil {
                //                let didConnect = self.bt.connectToDevice (
                //                    device: thisDevice,
                //                    savedIndex: deviceIndex )
                //                print("SavedDevRow -- connect to \(thisDevice.name) - " +
                //                        (didConnect ? "success" : "fail" ) )
                //
                //
                //            } // Connected to another desk, disconnect and connect to this
                
                
            }/*end button action*/ )
            { // Button View 'label'
                if self.bt.bluetoothEnabled,
                   self.bt.data.savedDevices.indices.contains(deviceIndex),
                   self.bt.data.savedDevices[deviceIndex].peripheral != nil {
                    
                    ZStack {
                        Circle()
                            .foregroundColor(isConnected ? ColorManager.connected : ColorManager.bgColor)
                            .aspectRatio(contentMode: .fit)
                            .shadow(color: .black, radius: 2)
                        if isConnected {
                            Image(systemName: "iphone.homebutton.slash")
                                .resizable()
                                .accentColor(ColorManager.deviceBG)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .accentColor(Color.red)
                                .aspectRatio(contentMode: .fit)
                                .background(ColorManager.connected.cornerRadius(20).frame(width: 18, height: 18))
                                .frame(height: 20)
                                .offset(x: 25, y: -20)
                                .shadow(color: ColorManager.connected, radius: 1)
                        } else {
                            Image(systemName: "iphone.homebutton.radiowaves.left.and.right") //"dot.radiowaves.left.and.right")
                                .resizable()
                                .accentColor(ColorManager.morePreset)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                        }
                        
                    }
                } else {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.gray)
                            .aspectRatio(contentMode: .fit)
                            .shadow(color: ColorManager.gray, radius: 2)
                        Image(systemName: "iphone.homebutton.radiowaves.left.and.right") //"dot.radiowaves.left.and.right")
                            .resizable()
                            .accentColor(ColorManager.gray)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                            .opacity(0.6)
                    }
                }
            } //end button
        }
    }//end body
}//end ConnectButton
*/

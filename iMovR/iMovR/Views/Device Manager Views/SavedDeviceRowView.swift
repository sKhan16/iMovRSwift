//
//  SavedDeviceRowView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/26/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct SavedDeviceRowView: View {
    
    //@EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var data: DeviceDataManager
    @Binding var edit: Int
    @Binding var isConnected: Bool
    let deviceIndex: Int
    
    let testSavedDevices: [Desk] = [
        Desk(name: "Main Office Desk", deskID: 10009810, presetHeights:[], presetNames: []),
        Desk(name: "Treadmill Home Office ", deskID: 54810, presetHeights:[], presetNames: []),
        Desk(name: "Home Desk", deskID: 56781234, presetHeights:[], presetNames: [])
    ]
    
    var body: some View {
        let currDevice = self.data.savedDevices[deviceIndex]
        //for preview testing
        //let currDevice = testSavedDevices[deviceIndex]
        HStack {
            ConnectButton( deviceIndex: self.deviceIndex,
                           isConnected: self.$isConnected
            )// end ConnectButton initializer
                .padding(.leading, 5)
                .frame(width:70, height:65)
            
            VStack {
                Text(currDevice.name)
                    .font(Font.title3.bold())
                    .truncationMode(.tail)
                    .foregroundColor(Color.white)
                if self.isConnected {
                    Text("Connected")
                        .font(Font.body.weight(.medium))
                        .foregroundColor(ColorManager.connected)
                }
                Text(String(currDevice.id))
                    .font(Font.caption)//.weight(.medium))
                    .foregroundColor(Color.white)
            }
                .lineLimit(1)
                .frame(idealWidth: .infinity, maxWidth: .infinity)
            
            EditButton(deviceIndex: self.deviceIndex, editIndex: $edit)
                .padding(.trailing, 5)
                .frame(width:70, height:65)
        }
        .frame(height: 75)
        .background(ColorManager.deviceBG)
        .cornerRadius(75/2.0)

        .shadow(color: .black, radius: 3, x: 0, y: 4)
        .padding([.leading, .trailing, .top], 2)
        .padding(.bottom, 8)
    }// end Body
}// end SavedDeviceRowView



private struct ConnectButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    let deviceIndex: Int
    @Binding var isConnected: Bool
    
    var body: some View {
        Button( action:{
            let thisDevice: Desk = self.bt.data.savedDevices[deviceIndex]
            if isConnected {
                let didDisconnect: Bool = bt.disconnectFromDevice(device: thisDevice, savedIndex: deviceIndex)
                print("Device Manager View: disconnect from device \(thisDevice.name) - " +
                        (didDisconnect ? "success" : "fail" ) )
            }
            else {
                if self.bt.connectToDevice(device: thisDevice, savedIndex: deviceIndex) {
                    print("connecting to device: \(thisDevice.name), id:\(thisDevice.id)")
                } else {
                    print("bt.connectToDevice attempt failed (device: \(thisDevice.name), id:\(thisDevice.id))")
                }
            }
        } ) { // Button 'label' View
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
        } //end button
    }//end body
}//end ConnectButton


private struct EditButton: View {
    let deviceIndex: Int
    @Binding var editIndex: Int
    
    var body: some View {
        Button(
            action:{
                print("edit device menu activated")
                self.editIndex = self.deviceIndex
            }
        ) {
            ZStack {
                Circle()
                    .foregroundColor(ColorManager.bgColor)
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: .black, radius: 2)
                Image(systemName: "wrench.and.screwdriver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.rotationEffect(.degrees(90))
                    .frame(height: 40)
                    .foregroundColor(ColorManager.morePreset)
            }
        }
    }//end body
}//end EditButton

struct SavedDeviceRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                SavedDeviceRowView(data: DeviceDataManager(), edit: .constant(0), isConnected: .constant(true), deviceIndex: 0)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 11")
            
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                SavedDeviceRowView(data: DeviceDataManager(), edit: .constant(0), isConnected: .constant(true), deviceIndex: 0)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 6s")
        }
    }
}

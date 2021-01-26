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
            //for preview testing
            //let currDevice = testSavedDevices[deviceIndex]
            HStack {
                ConnectButton( deviceIndex: self.deviceIndex,
                               isConnected: self.$isConnected
                )// end ConnectButton initializer
                    .padding(.leading, 5)
                    .frame(width:70, height:65)
                
                VStack {
                    VStack {
                        Text(currDevice.name)
                            .font(Font.title3.bold())
                            .truncationMode(.tail)
                            .foregroundColor(Color.white)
                        Text("("+String(currDevice.id)+")")
                            .font(Font.caption)//.weight(.medium))
                            .foregroundColor(Color.white)
                    }.offset(y: -3)
                    if self.isConnected {
                        Text("Connected")
                            .font(Font.body.weight(.medium))
                            .foregroundColor(ColorManager.connected)
                            .padding([.leading,.trailing], 3)
                    } else if self.data.savedDevices[deviceIndex].peripheral != nil {
                        Text("Available")
                            .font(Font.body.weight(.medium))
                            .foregroundColor(Color.white)
                            .padding([.leading,.trailing], 3)
                    } else {
                        Text("Not Found")
                            .font(Font.body.weight(.medium))
                            .foregroundColor(ColorManager.gray)
                            .padding([.leading,.trailing], 3)
                    }
                }
                .lineLimit(1)
                .frame(idealWidth: .infinity, maxWidth: .infinity)
                .offset(y: 1)
                
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
        }
    }// end Body
}// end SavedDeviceRowView



private struct ConnectButton: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    let deviceIndex: Int
    @Binding var isConnected: Bool
    
    var body: some View {
        
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
            if self.bt.data.savedDevices[deviceIndex].peripheral != nil {
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

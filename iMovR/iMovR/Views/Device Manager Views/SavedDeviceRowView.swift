//
//  SavedDeviceRowView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/26/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct SavedDeviceRowView: View {
    
    let testSavedDevices: [Desk] = [Desk(name: "Main Office Desk", deskID: 10009810), Desk(name: "Treadmill Home Office ", deskID: 54810), Desk(name: "Home Desk", deskID: 56781234)]//, Desk(name: "Conference Room Third Floor Desk", deskID: 10005326), Desk(name: "Office 38 Desk", deskID: 38801661), Desk(name: "Home Monitor Arm", deskID: 881004)]
    let testDiscoveredDevices: [Desk] = [Desk(name: "Discovered ZipDesk", deskID: 10007189), Desk(name: "Discovered ZipDesk", deskID: 10004955), Desk(name: "Discovered ZipDesk", deskID: 10003210)]
    
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var edit: Int
    let deviceIndex: Int
    
    //@Binding var isConnected: Bool
    @State var isConnected: Bool = true
    
    
    var body: some View {
//        let isConnectedLink = Binding(
//            get: { bt.connectedDeskIndex == self.deviceIndex },
//            set: { self.isConnected = $0 }
//        )
        let currDevice = self.bt.savedDevices[deviceIndex]
        
        HStack {
            ConnectButton(deviceIndex: self.deviceIndex, isConnected: self.$isConnected)
                .padding(.leading, 5)
                .frame(width:70, height:65)
            
            VStack {
                Text(currDevice.name)
                    .font(Font.title3.bold())
                    .truncationMode(.tail)
                    .foregroundColor(Color.white)
                Text(String(currDevice.id))
                    .font(Font.caption)//.weight(.medium))
                    .foregroundColor(Color.white)
                if isConnected {
                Text("Connected")
                    .font(Font.body.weight(.medium))
                    .foregroundColor(ColorManager.connected)
                }
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
                let thisDevice: Desk = self.bt.savedDevices[deviceIndex]
                if self.bt.connectToDevice(device: thisDevice, indexSavedDevices: deviceIndex) {
                    print("connecting to device: \(thisDevice.name), id:\(thisDevice.id)")
                } else {
                    print("bt.connectToDevice attempt failed (device: \(thisDevice.name), id:\(thisDevice.id))")
                }
            }
        ) { // Button label View
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
                
                SavedDeviceRowView(edit: .constant(0), deviceIndex: 0)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 11")
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                
                SavedDeviceRowView(edit: .constant(0), deviceIndex: 0)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 6s")
        }
    }
}

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
    @Binding var edit: Int
    let deviceIndex: Int
    
    // In final build, this array is type [Device] & comes from BTController or UserObservable
    let testSavedDevices: [Desk] = [Desk(name: "Main Office Desk", deskID: 10009810), Desk(name: "Treadmill Home Office ", deskID: 54810), Desk(name: "Home Desk", deskID: 56781234)]//, Desk(name: "Conference Room Third Floor Desk", deskID: 10005326), Desk(name: "Office 38 Desk", deskID: 38801661), Desk(name: "Home Monitor Arm", deskID: 881004)]
    let testDiscoveredDevices: [Desk] = [Desk(name: "Discovered ZipDesk", deskID: 10007189), Desk(name: "Discovered ZipDesk", deskID: 10004955), Desk(name: "Discovered ZipDesk", deskID: 10003210)]
    
    @State private var isConnected: Bool = false
     //@State var favorited: Bool = false
    
    var body: some View {
//        let isConnectedLink = Binding(
//            get: { bt.connectedDeskIndex == self.deviceIndex },
//            set: { self.isConnected = $0 }
//        )
        let currDevice = self.bt.savedDevices[deviceIndex]
        //keep for preview testing
        //let currDevice = testSavedDevices[deviceIndex]
        
        HStack {
            
            ConnectButton(deviceIndex: self.deviceIndex, isConnected: self.$isConnected)
                .frame(width:70, height:75)
                .offset(x: 3)
            
            //            Rectangle()
            //                .fill(Color.black)
            //                .frame(width: 2)
            
            //Spacer()
            VStack {
                Text(currDevice.name)
                    .font(Font.title3.bold())
                    .truncationMode(.tail)
                    .foregroundColor(Color.white)
                Text(String(currDevice.id))
                    .font(Font.body.weight(.medium))
                    .foregroundColor(Color.white)
            }
            .font(Font.title3)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .padding([.top,.bottom], 15)
            
            EditButton(deviceIndex: self.deviceIndex, editIndex: $edit)
                .frame(width:70, height:75)
                .accentColor(ColorManager.gray)
                .offset(x: 5)
        }
        .frame(height: 75)
        .background(ColorManager.deviceBG)
        .cornerRadius(75/2.0)
        //.border(Color.black, width: 3)
        //        .overlay(
        //            RoundedRectangle(cornerRadius: 20)
        //                .stroke(Color.black, lineWidth: 2)
        //        )
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
                    .foregroundColor(Color.blue)
                    .aspectRatio(contentMode: .fit)
                Image(systemName: "iphone.homebutton.radiowaves.left.and.right") //"dot.radiowaves.right")//"dot.radiowaves.left.and.right")
                    .resizable()
                    .accentColor(isConnected ? ColorManager.preset : ColorManager.morePreset)
                    //.rotationEffect(.degrees(-90))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                
                //RoundedRectangle(cornerRadius: 20)
                //  .stroke(Color.black, lineWidth: 2)
            }
        }
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
                Image(systemName: "wrench.and.screwdriver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.rotationEffect(.degrees(90))
                    .frame(height: 40)
                
                //RoundedRectangle(cornerRadius: 20)
                //  .stroke(Color.black, lineWidth: 2)
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

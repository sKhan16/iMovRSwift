//
//  DeviceManagerView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeviceManagerView: View {
    
    @EnvironmentObject var bt: ZGoBluetoothController
    @EnvironmentObject var user: UserObservable
    
    // In final build, this array is type [Device] & comes from BTController or UserObservable
    let testSavedDevices: [Desk] = [Desk(name: "Main Office Desk", deskID: 10009810), Desk(name: "Conference Room Third Floor Desk", deskID: 10005326), Desk(name: "Office 38 Desk", deskID: 38801661), Desk(name: "Treadmill Home Office ", deskID: 54810), Desk(name: "Home Desk", deskID: 56781234), Desk(name: "Home Monitor Arm", deskID: 881004)]
    let testDiscoveredDevices: [Desk] = [Desk(name: "Discovered ZipDesk", deskID: 10007189), Desk(name: "Discovered ZipDesk", deskID: 10004955), Desk(name: "Discovered ZipDesk", deskID: 10003210)]
    
    @State var deviceEditIndex: Int = -1
    @State private var safetyDummyIndex: Int = -1
    
    var body: some View {
        let testDevices = testSavedDevices + testDiscoveredDevices
        ZStack {
            VStack {
                Text("Device Manager")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(Color.white)
                    .padding()
                ScrollView {
                    Text("Saved Devices")
                        .foregroundColor(Color.white)
                        .font(Font.title2)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(Range(0...6)) { index in
                        VStack {
                            DeviceRowView(edit: $deviceEditIndex, deviceIndex: index)
                            //.cornerRadius(10.0)
                            .padding(2)
                        }
                    }
                        //.border(Color.blue, width: 3)
                        .background(ColorManager.bgColor)
                        .cornerRadius(20.0)
                        //.padding(5)
                        .frame(maxWidth: .infinity)
                    
                    Text("DiscoveredDevices")
                        .foregroundColor(Color.white)
                        .font(Font.title2)
                        .padding([.leading,.top])
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(Range(6...8)) { index in
                        VStack {
                            DeviceRowView(edit: $safetyDummyIndex, deviceIndex: index)
                                .padding(2)
                        }
                        
                    }
                    //.border(Color.yellow, width: 3)
                    .background(ColorManager.bgColor)
                    .cornerRadius(15.0)
                    .frame(maxWidth: .infinity)
                }
                .padding(2)
                //.border(Color.red, width: 3)
                
            }//end VStack
            
            // Popup for editing saved device properties
            if (deviceEditIndex != -1) {
                DeviceEditView(deviceIndex: $deviceEditIndex, selectedDevice: testDevices[deviceEditIndex])
            }
        }/*end ZStack*/.animation(.easeInOut)
    } //end Body
    
}

struct DeviceManagerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                
                DeviceManagerView()
            }
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                
                DeviceManagerView()
            }
            .previewDevice("iPhone 6s")
        }
    }
}

//
//  DiscoveredDeviceRowView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/26/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DiscoveredDeviceRowView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var save: Int
    let deviceIndex: Int
    
    // In final build, this array is type [Device] & comes from BTController or UserObservable
    //let testSavedDevices: [Desk] = [Desk(name: "Main Office Desk", deskID: 10009810), Desk(name: "Treadmill Home Office ", deskID: 54810), Desk(name: "Home Desk", deskID: 56781234)]//, Desk(name: "Conference Room Third Floor Desk", deskID: 10005326), Desk(name: "Office 38 Desk", deskID: 38801661), Desk(name: "Home Monitor Arm", deskID: 881004)]
    let testDiscoveredDevices: [Desk] = [Desk(name: "Discovered ZipDesk", deskID: 10007189, presetHeights:[], presetNames: []), Desk(name: "Discovered ZipDesk", deskID: 10004955, presetHeights:[], presetNames: []), Desk(name: "Discovered ZipDesk", deskID: 10003210, presetHeights:[], presetNames: [])]
    @ViewBuilder
    var body: some View {
        if self.bt.discoveredDevices.indices.contains(deviceIndex) {
            let currDevice = self.bt.discoveredDevices[deviceIndex]
            HStack {
                SaveButton(deviceIndex: self.deviceIndex, saveIndex: $save)
                    .offset(x: 5)
                    .frame(width:75, height:75)
                    .accentColor(ColorManager.morePreset)
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
                Rectangle()
                    .frame(width:75, height:75)
                    .foregroundColor(ColorManager.deviceBG)
            }
            .frame(height: 75)
            .background(ColorManager.deviceBG)
            .cornerRadius(20)
            .shadow(color: .black, radius: 3, x: 0, y: 4)
            .padding([.leading, .trailing, .top], 2)
            .padding(.bottom, 8)
        } else {
            EmptyView()
        }
    }
}

private struct SaveButton: View {
    let deviceIndex: Int
    @Binding var saveIndex: Int
    
    var body: some View {
        Button(
            action:{
                print("save device menu activated")
                self.saveIndex = self.deviceIndex
            }
        ) {
            ZStack {
                Image(systemName: "plus.rectangle.fill.on.folder.fill")//"badge.plus.radiowaves.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.rotationEffect(.degrees(90))
                    .frame(minWidth: 40, idealWidth: 50, maxWidth: 50)
                
                //RoundedRectangle(cornerRadius: 20)
                //  .stroke(Color.black, lineWidth: 2)
            }
        }
    }//end body
}//end EditButton

struct DiscoveredDeviceRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                
                DiscoveredDeviceRowView(save: .constant(0), deviceIndex: 0)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 11")
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                
                DiscoveredDeviceRowView(save: .constant(0), deviceIndex: 0)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 6s")
        }
    }
}

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
    
    let testDiscoveredDevices: [Desk] = [Desk(name: "Discovered ZipDesk", deskID: 10007189, presetHeights:[], presetNames: [], isLastConnected: false), Desk(name: "Discovered ZipDesk", deskID: 10004955, presetHeights:[], presetNames: [], isLastConnected: false), Desk(name: "Discovered ZipDesk", deskID: 10003210, presetHeights:[], presetNames: [], isLastConnected: false)]
    
    @ViewBuilder
    var body: some View {
        if !self.bt.discoveredDevices.indices.contains(deviceIndex) {
            EmptyView()
        } else {
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
                        .foregroundColor(ColorManager.royalBlue)
                    Text("("+String(currDevice.id)+")")
                        .font(Font.body.weight(.medium))
                        .foregroundColor(ColorManager.royalBlue)
                }
                .font(Font.title3)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding([.top,.bottom], 15)
                .padding(.trailing, 75)
            }
            .frame(height: 75)
            .background(
                Image("DeviceRowBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height:75)
            )
            //.cornerRadius(75/2.0)
            //.shadow(color: .black, radius: 3, x: 0, y: 4)
            .padding([.leading, .trailing, .top], 2)
            .padding(.bottom, 8)
        }
    }
}

private struct SaveButton: View {
    let deviceIndex: Int
    @Binding var saveIndex: Int
    
    var body: some View {
        Button(
            action:{
                print("SaveDeviceView activated")
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

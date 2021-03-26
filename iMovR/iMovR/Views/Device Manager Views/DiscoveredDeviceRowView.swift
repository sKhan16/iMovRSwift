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
    
    @ViewBuilder
    var body: some View {
        if !self.bt.discoveredDevices.indices.contains(deviceIndex)
        {
            EmptyView()
        }
        else
        {
            let currDevice = self.bt.discoveredDevices[deviceIndex]
            HStack
            {
                VStack {
                    Text(currDevice.name)
                        .font(.system(size: 20)).bold()
                        .truncationMode(.tail)
                        .foregroundColor(ColorManager.buttonPressed)
                    Text("("+String(currDevice.id)+")")
                        //"(\(currDevice.id)) RSSI: " + String(Float(truncating: currDevice.rssi ?? 1337.0)))
                        .font(Font.body)
                        .foregroundColor(ColorManager.buttonPressed)
                }
                    .font(Font.title3)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 57)
                
                SaveButton(deviceIndex: self.deviceIndex, saveIndex: $save)
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
    }
}

private struct SaveButton: View {
    let deviceIndex: Int
    @Binding var saveIndex: Int
    
    var Unpressed: Image = Image("ButtonRoundDark")
    var Pressed: Image = Image("ButtonRoundDarkBG")
    @State private var isPressed: Bool = false
    
    var body: some View {
        ZStack {
            (isPressed ? Pressed : Unpressed)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(ColorManager.buttonPressed)
                .frame(width: 28, height: 28)
        }
        .gesture (
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    isPressed = true
                    print("SaveDeviceView activated")
                    self.saveIndex = self.deviceIndex
                })
                .onEnded({ _ in
                    isPressed = false
                })
        )
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
            .previewDevice("iPhone 12")
//            ZStack {
//                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
//                DiscoveredDeviceRowView(save: .constant(0), deviceIndex: 0)
//                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
//            }
//            .previewDevice("iPhone 6s")
        }
    }
}

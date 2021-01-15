//
//  PresetEditOptions.swift
//  iMovR
//
//  Created by Michael Humphrey on 1/14/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditOptions: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
//    @ObservedObject var data: DeviceDataManager
    
//    @Binding var presetName: String
//    @Binding var presetHeight: String
//    @Binding var isInvalidInput: Bool
    @Binding var editIndex: Int
    
    var body: some View {
        VStack {
            Text("Preset Settings")
                .font(Font.title)
                .foregroundColor(.white)
                .padding(.top, 5)
            ForEach(Range(0...5)) { index in
                PresetSelectButton (
                    data: self.bt.data,
                    index: index,
                    editIndex: self.$editIndex
                )
                .padding([.leading, .trailing], 30)
                .padding([.top, .bottom], 5)
            }
        }
        .padding([.top,.bottom], 5)
    }// end Body
}// end PresetEditOptions


private struct PresetSelectButton: View {
    @ObservedObject var data: DeviceDataManager
    
    let index: Int
    @Binding var editIndex: Int
    
    var body: some View {
        Button (
            action: {
                if data.connectedDeskIndex != nil {
                    self.editIndex = index
                }
            },
            label: {
                if data.connectedDeskIndex != nil {
                    let currDesk: Desk = data.savedDevices[data.connectedDeskIndex!]
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(ColorManager.deviceBG)
                            .frame(height: 40)
                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                        
                        Text(
                            //"Edit \(presetName):  " +
                            //    ((presetHeight > -1.0) ? String(format:"%.1f",presetHeight) : "Unassigned")
                            "Edit \(currDesk.presetNames[index]):  " +
                                ((currDesk.presetHeights[index] > -1) ? String(currDesk.presetHeights[index]) : "Empty")
                        )
                    }
                }
            }
        )
        .accentColor(.white)

    }
}


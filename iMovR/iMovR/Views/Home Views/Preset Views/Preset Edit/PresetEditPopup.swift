//
//  PresetEditPopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditPopup: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @EnvironmentObject var user: UserDataManager
    
    @Binding var show: Bool
    @Binding var isTouchGo: Bool
    @State private var tngLink: Bool = false
    
    @State private var showTnGPopup: Bool = false
    
    @State private var editIndex: Int = -1
    
    
    var body: some View {
        
        ZStack {
            // Background color filter & back button
            Button(action: {self.show = false}, label: {
                Rectangle()
                    .fill(ColorManager.bgColor)
                    .opacity(0.75)
                    .edgesIgnoringSafeArea(.top)
            })
            
            VStack {
               // Display Presets List
                if bt.data.connectedDeskIndex == nil {
                    Text("Preset Settings")
                        .font(Font.title)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                    Text("Please Connect To A Device")
                        .font(Font.title2.bold())
                        .foregroundColor(.white)
                }
                else if self.editIndex == -1 {
                    VStack {
                        PresetEditOptions (
                            editIndex: self.$editIndex
                        )
                        TnGToggle (isTouchGo: self.$isTouchGo, showTnGPopup: self.$showTnGPopup)
                            .padding(5)
                    }
                }
                else { /* if self.editIndex != -1, bt.data.connectedDeskIndex != nil */
                    SelectedPresetEditMenu(editIndex: self.$editIndex)
                }
            } //end main level VStack
            .frame(idealWidth: 300, maxWidth: 300, idealHeight: 450, maxHeight: 450, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
            
            if self.showTnGPopup {
                TouchNGoPopup(isTouchGo: self.$isTouchGo, showTnGPopup: self.$showTnGPopup)
            }
        }//end ZStack
    }//end Body
}


struct PresetEditPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            PresetEditPopup (
                show: .constant(true),
                isTouchGo: .constant(true)
            )
            .environmentObject(UserDataManager())
            .environmentObject(DeviceBluetoothManager(previewMode: true)!)
        }
    }
}

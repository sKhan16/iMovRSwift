//
//  InactivePopup.swift
//  iMovR
//
//  Created by Shakeel Khan on 5/7/21.
//  Copyright © 2021 iMovR. All rights reserved.


import SwiftUI

struct InactivePopup: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @EnvironmentObject var user: UserDataManager
    @ObservedObject var data: DeviceDataManager
    
    @Binding var show: Bool
    // @Binding var isTouchGo: Bool   replaced by 'user.tngEnabled'
   
    
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
            
                Text("Preset Settings")
                    .font(Font.title)
                    .foregroundColor(ColorManager.buttonPressed)
                    .padding(.top, 5)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(ColorManager.buttonPressed)
                
                if self.data.devicePickerIndex != nil {
                    Text("Connect To \(self.data.savedDevices[self.data.devicePickerIndex!].name)")
                        .font(Font.title2.bold())
                        .foregroundColor(ColorManager.buttonPressed)
                }
                
         
           
            } //end main level VStack
            .frame(idealWidth: 300, maxWidth: 300, idealHeight: 450, maxHeight: 450, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
            
        }//end ZStack
    }//end Body
}


struct InactivePopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            PresetEditPopup (
                show: .constant(true)
            )
            .environmentObject(UserDataManager())
            .environmentObject(DeviceBluetoothManager(previewMode: true)!)
        }
    }
}


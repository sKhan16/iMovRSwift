//
//  DeviceEditView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeviceEditView: View {
    
    @EnvironmentObject var bt: ZGoBluetoothController
    @EnvironmentObject var user: UserObservable
    
    @Binding var deviceIndex: Int
    var selectedDevice: Desk

    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.gray)
                .opacity(0.5)

            VStack {
                VStack {
                    Text(selectedDevice.name)
                    Text(String(selectedDevice.id))
                }
                .font(Font.largeTitle.bold())
                .foregroundColor(Color.white)
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 250, idealHeight: 100, maxHeight: 250, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 27).fill(Color.blue.opacity(1)))
            .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color.black, lineWidth: 1))

        }//end ZStack
        .onTapGesture { self.deviceIndex = -1 }
        // Goes back when tapped outside of edit window
    }//end Body
}

struct DeviceEditView_Previews: PreviewProvider {

    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
        
            DeviceEditView(deviceIndex: .constant(0), selectedDevice: Desk(name: "Office Desk 1", deskID: 12345678))
        }
    }
}

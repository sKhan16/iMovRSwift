//
//  EditDeviceView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/8/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EditDeviceView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var deviceIndex: Int
    var selectedDevice: Desk
    
//    init(deviceIndex: Binding<Int>, selectedDevice: Desk){
//        self._deviceIndex = deviceIndex
//        self.selectedDevice = selectedDevice
//        UITableView.appearance().backgroundColor = .clear
//    }
    
    @State var editName: String = ""
//    @State var editID: String = ""
    
    var body: some View {
        ZStack{
            // Background color filter & back button
            Button(action: {self.deviceIndex = -1}, label: {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
                    //.blur(radius: 3.0)
            })
            VStack {
                
                VStack {
                    ZStack {
                    Text("Edit Device")
                        .font(Font.title.weight(.medium))
                        .padding(5)
                        Button(action: {self.deviceIndex = -1}, label: {
                            Text("Back")
                                .font(Font.caption)
                                .frame(width: 50, height: 28)
                                .offset(x:-1)
                                .background(Color.red)
                                .cornerRadius(13)
                                .shadow(radius: 3)
                                
                            
                        })
                        .offset(x: -116, y: -14)
                    }
                    Rectangle()
                        .foregroundColor(Color.black)
                        .frame(maxWidth:.infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                    VStack {
                        Text(selectedDevice.name)
                            .font(Font.title3.weight(.medium))
                        Text("ZipDesk ID: " + String(selectedDevice.id))
                            .font(Font.body.monospacedDigit().weight(.regular))
                            .padding(.top,1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    //.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    //.padding([.leading,.trailing])
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("Change Device Name?")
                        .foregroundColor(Color.white)
                        .font(Font.body.weight(.medium))
                        .offset(y:8)
                    TextField(" new name", text: $editName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    /*
                    Text("Device ID:")
                        .foregroundColor(Color.white)
                        .font(Font.body.weight(.medium))
                        .padding(.top, 10)
                        .offset(y:8)
                    TextField("change id?", text: $editID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    */
                }
                .padding()
                Spacer()
                
                Button(action: {
                    print("saving 'edit device' changes")
                    var changedDevice = self.selectedDevice
                    changedDevice.name = editName
                    self.bt.data.editDevice(desk: changedDevice)
                    self.deviceIndex = -1
                    
                }, label: {
                    Text("Save Changes")
                        .font(Font.title3.bold())
                        .foregroundColor(Color.white)
                        .padding()
                        .background(ColorManager.preset)
                        .cornerRadius(20)
                        .shadow(radius: 8)
                })
                .frame(width:200,height:100)
                
                
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()

        }//end ZStack
        //.onTapGesture { self.deviceIndex = -1 }
        // Goes back when tapped outside of edit window
    }//end Body
}

struct EditDeviceView_Previews: PreviewProvider {

    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            //DeviceManagerView()
        
            EditDeviceView(deviceIndex: .constant(0), selectedDevice: Desk(name: "Office Desk 1", deskID: 12345678, presetHeights:[], presetNames: []))
        }
    }
}

//
//  DeviceRowView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeviceRowView: View {

    @Binding var edit: Int
    let deviceIndex: Int
    
    // In final build, this array is type [Device] & comes from BTController or UserObservable
    let testSavedDevices: [Desk] = [Desk(name: "Main Office Desk", deskID: 10009810), Desk(name: "Conference Room Third Floor Desk", deskID: 10005326), Desk(name: "Office 38 Desk", deskID: 38801661), Desk(name: "Treadmill Home Office ", deskID: 54810), Desk(name: "Home Desk", deskID: 56781234), Desk(name: "Home Monitor Arm", deskID: 881004)]
    let testDiscoveredDevices: [Desk] = [Desk(name: "Discovered ZipDesk", deskID: 10007189), Desk(name: "Discovered ZipDesk", deskID: 10004955), Desk(name: "Discovered ZipDesk", deskID: 10003210)]
    
    /*
    @State var isConnected: Bool = false
    @State var favorited: Bool = false
    */
    
    var body: some View {
        //testing
        let testDevices = testSavedDevices + testDiscoveredDevices

        let currDevice = testDevices[deviceIndex]
        
        HStack {
            
            ConnectButton(deviceIndex: self.deviceIndex)
                .frame(width:75, height:75)
                .accentColor(ColorManager.morePreset)
            
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
                .frame(width:75, height:75)
                .accentColor(ColorManager.gray)
        }
        .frame(minHeight: 75, idealHeight: 75, maxHeight: 75)
        .background(ColorManager.deviceBG)
        .cornerRadius(20)
        //.border(Color.black, width: 3)
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.black, lineWidth: 2)
//        )
        .shadow(color: .black, radius: 3, x: 0, y: 5)
    }
}


private struct ConnectButton: View {
    let deviceIndex: Int
    
    var body: some View {
        Button(
            action:{
                print("clicked device row \(deviceIndex) connect button")
                //bt.connect(...to current device...)
            }
        ) {
            ZStack {
                Image(systemName: "dot.radiowaves.right")//"dot.radiowaves.left.and.right")
                    .resizable()
                    .rotationEffect(.degrees(-90))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                
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
                Image(systemName: "gearshape.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.rotationEffect(.degrees(90))
                .frame(minWidth: 30, idealWidth: 40, maxWidth: 40)
                
                //RoundedRectangle(cornerRadius: 20)
                  //  .stroke(Color.black, lineWidth: 2)
            }
        }
    }//end body
}//end EditButton

struct DeviceRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRowView(edit: .constant(0), deviceIndex: 0)
    }
}

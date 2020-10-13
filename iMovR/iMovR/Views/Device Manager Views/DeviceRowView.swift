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
            Button(
                action:{
                    print("clicked device row \(deviceIndex) connect button")
                    //bt.connect(...to current device...)
                }
            ) { Image(systemName: "dot.radiowaves.left.and.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 30, idealWidth: 50, maxWidth: 50, minHeight: 40)
                //.frame(width: 40)
                .padding(.leading, 10)
            }
            
            //Spacer()
            VStack {
                Text(currDevice.name)
                    .bold()
                    .truncationMode(.tail)
                Text(String(currDevice.id))
                    .font(Font.body)
            }
                .font(Font.title3)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            .padding([.top,.bottom], 15)
            Button(
                action:{
                    print("edit device menu activated")
                    self.edit = self.deviceIndex
                }
            ) { Image(systemName: "ellipsis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(90))
                .frame(minWidth: 20, idealWidth: 30, maxWidth: 30, minHeight: 40)
                .padding([.trailing], 10)

                
            }
                
        }
        .background(Color.white)
        .cornerRadius(20)
        //.border(Color.black, width: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
        )
        
    }
}

struct DeviceRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRowView(edit: .constant(0), deviceIndex: 0)
    }
}

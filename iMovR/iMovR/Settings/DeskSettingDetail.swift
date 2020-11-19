//
//  DeskSettingDetail.swift
//  iMovR
//
//  Created by Michael Humphrey on 8/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeskSettingDetail: View {

    //TODO: Get needed variables
    // var name: String
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: DeviceBluetoothManager

    var currIndex: Int
    //var name: String
    
    @State var canConnect: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: EditDesk(currIndex: self.currIndex)) {
                /*Button(action: {print("TEST")}) {
                 Text("Edit Name")
                 .padding()
                 .background(Color.gray)
                 .foregroundColor(.white)
                 .font(.title)*/
                Text("Edit Desk")
                //}
                
                //.padding()
            }.buttonStyle(PlainButtonStyle())
                
                .padding()
            
            Button (action: {
                self.showAlert = true
                //if (self.canConnect) {
                //self.user.presets.remove(at: self.currIndex)
                //print("Removed")
                //self.canConnect = false
                //}
                
            }) {
                Text("Connect To Desk")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Connect to desk \(user.desks[currIndex].name)?"), primaryButton: .default(Text("Confirm")) {
                    let selectedDesk: Desk = self.user.desks[self.currIndex]
                    if !self.canConnect {
                        self.canConnect = true
                    }
                    if self.canConnect {
                        print("connection to desk \(selectedDesk.name) started")
                        self.user.currentDesk = selectedDesk
                        self.bt.connectToDevice(device: selectedDesk, savedIndex: -1)
                        self.canConnect = false
                    }
                    },  secondaryButton: .destructive(Text("Cancel")))
            }

        }
        //.navigationBarTitle(Text(""))
        //.navigationBarHidden(true)
    }
}


struct deskConfirmAlert: View {
    
    @EnvironmentObject var user: UserObservable
    
    @Binding var showAlert: Bool
    @Binding var canConnect: Bool
    //var currIndex: Int
    
    var body: some View {
        Button(action: {
            self.canConnect = true
        }) {
            Text("Confirm")
        }
    }
}



struct DeskSettingDetail_Previews: PreviewProvider {
    static var previews: some View {
        DeskSettingDetail(currIndex: 0)
    }
}

//
//  BTConnectButton.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/22/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct BTConnectButton: View {
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var showBTConnect: Bool
    
    var body: some View {
        VStack {
            Text(bt.connectionStatus)
                .foregroundColor(bt.connectionColor)
                .padding()
            
            Button(action: {
                self.showBTConnect = true
            }) {
                VStack {
                    Text("Connect")
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(red: 227/255, green: 230/255, blue: 232/255))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
            .sheet(isPresented: self.$showBTConnect) {
                BTConnectView(showBTConnect: self.$showBTConnect).environmentObject(self.bt)
                    .environmentObject(self.user)
            }
        }
    }
}

struct BTConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        BTConnectButton(showBTConnect: .constant(false)).environmentObject(DeviceBluetoothManager())
    }
}

//
//  DiscoveredDevicesView.swift
//  iMovR
//
//  Created by Michael Humphrey on 9/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DiscoveredDevicesView: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    var body: some View {
        List {
            /// modified code from DeskSettingView to use bt.discoveredDevices;
            ///# still needs more changes to function right
            if bt.discoveredDevices.count > 0 {
                ForEach(bt.discoveredDevices.indices, id: \.self) { index in
                    Button(action: {
                        self.bt.connectToDevice(device: self.bt.discoveredDevices[index])
                        
                    }) {
                        Text("Device #\(self.bt.discoveredDevices[index].id)")
                    }
                        /*
                        DeskSettingDetail(currIndex: index) ) {
                                SettingRow(name: self.bt.discoveredDevices[index].name, id:
                                    String(self.bt.discoveredDevices[index].id))
                        }
                        */
                        //.navigationBarTitle("Connect To Desk")
                }
            }
            
        }
    }
}

struct DiscoveredDesksView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredDevicesView()
    }
}

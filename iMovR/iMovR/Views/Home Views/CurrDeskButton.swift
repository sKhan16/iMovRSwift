//
//  CurrDeskButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 6/24/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI


struct CurrDeskButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @EnvironmentObject var user: UserDataManager
    @ObservedObject var data: DeviceDataManager
    
    var body: some View {
        Button(action: {
            
            self.data.devicePickerIndex = self.data.connectedDeskIndex
        }) {
            Text("Return to connected desk")
                .padding(10.0)
                .foregroundColor(Color.white)
                .background(Color.blue)
                /*.overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                    )*/
                
        }
    }
}

struct CurrDeskButton_Previews: PreviewProvider {
    static var previews: some View {
        CurrDeskButton( data: DeviceDataManager())
    }
}

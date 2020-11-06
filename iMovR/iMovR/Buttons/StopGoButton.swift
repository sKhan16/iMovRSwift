//
//  StopGoButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 9/11/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
import SwiftUI

struct StopGoButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    var body: some View {
        Button(action: {
            self.bt.zipdesk.releaseDesk()
            print("Stop Timer fired b4 interval")
            let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
                    print("Stop Timer fired after interval!")
                self.bt.zipdesk.releaseDesk()
                    timer.invalidate()
                }
            }) {
            Text("Stop")
            .fontWeight(.bold)
            .font(.title)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(5)
            .background(Color.red)
            .cornerRadius(40)
            .foregroundColor(.white)
            //.padding(10)
            /*.overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.purple, lineWidth: 0)
            )*/
            }
    }
}

struct StopGoButton_Previews: PreviewProvider {
    static var previews: some View {
        StopGoButton()
    }
}

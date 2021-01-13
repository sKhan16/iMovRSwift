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
    @State private var stopTimer: Timer?
    
    var body: some View {
        Button( action: {
            self.bt.zipdesk.releaseDesk()
            
            self.stopTimer = Timer.scheduledTimer (
                withTimeInterval: 0.3,
                repeats: false )
            { timer in
                self.bt.zipdesk.releaseDesk()
            }
        } ) { // button View 'Label'
            VStack {
                Spacer()
                Text("Stop")
                    //.font(Font.largeTitle.weight(.bold))
                    .font(Font.custom("largeTitle", size: 50.0))
                    .frame(maxWidth: .infinity, idealHeight: 80, maxHeight: 80)
                    .background(Color.red)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 15)
                    .padding(.bottom, (200/2 - 80/2))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }//end Button View 'Label'
        .onAppear() {
            withAnimation(.easeIn(duration: 5),{})
        }
        .onDisappear() {
            stopTimer?.invalidate()
            stopTimer = nil
            withAnimation(.easeOut(duration: 5),{})
        }
    }//end Body
}

struct StopGoButton_Previews: PreviewProvider {
    static var previews: some View {
        StopGoButton()
    }
}

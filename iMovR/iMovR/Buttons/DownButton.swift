//
//  DownButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DownButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @State private var pressed: Bool = false
    @Binding var testHeight: Float
    
    var body: some View {
        Button(action: {
            // What to perform
            
            if self.testHeight > 23.0 {
                self.testHeight -= 1.0
                print("Moving down!")
            } else {
                print("Reached minimum height")
            }
            
        }) {
            // How the button looks like
            Image(systemName: "chevron.down")
                .resizable()
                .frame(maxWidth: 90, minHeight: 70, idealHeight: 80, maxHeight: 80)
                .foregroundColor(Color.white)
                
                .onLongPressGesture(minimumDuration: 7, maximumDistance: CGFloat(50), pressing: { pressing in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.pressed = pressing
                    }
                    if pressing {
                        self.bt.zipdesk.lowerDesk()
                        print("My long press starts")
                        //print("     I can initiate any action on start")
                    } else {
                        self.bt.zipdesk.releaseDesk()
                        print("My long press ends")
                        //print("     I can initiate any action on end")
                    }
                }, perform: {})
                
                .simultaneousGesture(
                    // sends additional command for case when desk is asleep
                    LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                        .onEnded() { _ in
                            self.bt.zipdesk.lowerDesk()
                            print("simultaneous long press upButton")
                    }
                )
        }
        .padding()
    }
}


struct DownButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
        DownButton(testHeight: .constant(23.0)).environmentObject(DeviceBluetoothManager())
        }
    }
}

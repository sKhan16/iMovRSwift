//
//  UpButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//


/*
 Animation problems:
 - Adding .animation(...) didn't work with the buttons.
 - The problem is that our timers interrupt the UI state of the button
 - Putting timer changes in another thread/asynchronous queue might help.
 
            //Synchronous queue might freeze app when timer triggers, or maybe not.
            //This would be the safer option if the app doesn't hang up with it.
            DispatchQueue.main.sync { () -> Void in
                // your code here
                
            }
 
            //Asynchronous queue will cause less hang-ups, but may cause unexpected behavior.
            //This is less ideal but might work if synchronous queue freezes the app.
            DispatchQueue.main.async { () -> Void in
                // your code here

            }
 
 
 */



import SwiftUI

struct UpButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var pressed: Bool
    @Binding var unpressedTimer: Timer?
    @State private var animate: Bool = false
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: "chevron.up")
            .resizable()
            .frame(maxWidth: 90, minHeight: 70, idealHeight: 80, maxHeight: 80)
            .foregroundColor(self.animate ? Color.gray : Color.white)
                
            .onLongPressGesture (
                minimumDuration: 15,
                maximumDistance: CGFloat(50),
                pressing: { pressing in
                    if pressing {
                        self.pressed = true
                        self.animate = true
                        self.unpressedTimer?.invalidate()
                        self.unpressedTimer = nil
                        self.bt.zipdesk.raiseDesk()
                        print("press UP")
                    }
                    else { // unpressed UpButton
                        self.bt.zipdesk.releaseDesk()
                        self.unpressedTimer = Timer.scheduledTimer (
                            withTimeInterval: 1.5,
                            repeats: false
                        ) { timer in
                            print("release UP -> timer")
                            self.pressed = false
                            self.animate = false
                        }
                    }
                },
                perform: {}
            )
            
            .simultaneousGesture (
                // additional move command in case desk was asleep
                LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                    .onEnded() { _ in
                        self.bt.zipdesk.raiseDesk()
                }
            )
        }
        .padding()
    }
}


struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            UpButton(pressed: .constant(false), unpressedTimer: .constant(nil))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

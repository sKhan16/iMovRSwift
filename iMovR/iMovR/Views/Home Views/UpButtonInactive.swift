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

struct UpButtonInactive: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var pressed: Bool
    @Binding var unpressedTimer: Timer?
    @Binding var showInactivePopup: Bool
    
    var Unpressed = Image("UpButton")
    var Pressed = Image("UpButtonPressed")
    
    @State private var ButtonBG = false
    @State private var animateColor: Color = Color.white
    @State private var animateBlur: CGFloat = CGFloat(0.0)
    @State private var animateOpacity: Double = 1.0
    
    var body: some View {
        Button(action: {})
        {
            (ButtonBG ? Pressed : Unpressed)
                .resizable()
                .frame(maxWidth: 100, minHeight: 90, idealHeight: 100, maxHeight: 150)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ _ in
                            ButtonBG = true
                        })
                        .onEnded({ _ in
                            ButtonBG = false
                        }))
                .onLongPressGesture (
                    minimumDuration: 15,
                    maximumDistance: CGFloat(50),
                    pressing: { pressing in
                        self.pressed = pressing
                        if pressing { // press begun
                            self.showInactivePopup = true
                            
                        }
                    },
                    perform: {}
                )
//                .foregroundColor(animateColor)
//                .blur(radius: animateBlur)
//                .opacity(animateOpacity)
                
        }
    }
}


struct UpButtonInactive_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            UpButton(data: DeviceDataManager(), pressed: .constant(false), unpressedTimer: .constant(nil), showInactivePopup: .constant(false))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}

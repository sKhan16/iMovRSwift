//
//  HoldButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/29/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HoldButton: View {
    
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @State private var pressed: Bool = false
    
    @Binding var presetName: String
    @Binding var presetHeight: Float
    
    var body: some View {
        //var formatHeight = String(format: "%.1f", self.$presetHeight)
        ZStack {
            RoundedRectangle(cornerRadius: 10)//.strokeBorder(Color(red: 227/255, green: 230/255, blue: 232/255), lineWidth: 30)
                .fill(Color(red: 227/255, green: 230/255, blue: 232/255))
                .frame(width:250, height: 70)
                .shadow(radius: 5)
                .onLongPressGesture(minimumDuration: 7, maximumDistance: CGFloat(50), pressing: { pressing in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.pressed = pressing
                    }
                    if pressing {
                        self.bt.deskWrap?.moveToHeight(PresetHeight: self.presetHeight)
                        print("My long press starts")
                        //print("     I can initiate any action on start")
                    } else {
                        self.bt.deskWrap?.releaseDesk()
                        print("My long press ends")
                        //print("     I can initiate any action on end")
                    }
                }, perform: {})
                
                .simultaneousGesture(
                    // sends additional command for case when desk is asleep
                    LongPressGesture(minimumDuration: 0.2, maximumDistance: CGFloat(50))
                        .onEnded() { _ in
                            self.bt.deskWrap?.moveToHeight(PresetHeight: self.presetHeight)
                            print("simultaneous long press upButton")
                    }
                    
                )
            Text("Move to: \(String(format: "%.1f", self.presetHeight))")

            .padding(.leading, 80)
            .padding(.trailing, 80)
            .padding(.top, 40)
            .padding(.bottom, 40)
            //.background(Color(red: 227/255, green: 230/255, blue: 232/255))
            .font(.system(size: 1000))
            .minimumScaleFactor(0.01)
            .foregroundColor(.black)
            .lineLimit(1)
            //.font(.title)
            
        }
        
    }
}

struct HoldButton_Previews: PreviewProvider {
    static var previews: some View {
        HoldButton(presetName: .constant("Sitting"), presetHeight: .constant(Float(0.0.rounded())))
    }
}

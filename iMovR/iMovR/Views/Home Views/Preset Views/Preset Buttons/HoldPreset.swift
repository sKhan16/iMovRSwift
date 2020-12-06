//
//  HoldPreset.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/20/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HoldPreset: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @Binding var presetHeight: Float
    
    @State private var pressed: Bool = false
    

    
    
    //@State var tapped = false
    
    //@Binding var presetName: String
    //@Binding var presetHeight: Float
    
    var body: some View {
        Button(action: {
            //self.moveToPreset()
            //print("Moved to \(self.presetVal)")
            
            
        }) {
            VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        //.stroke(Color.black, lineWidth: 3)
                        //.background(Circle().foregroundColor(ColorManager.preset))
                        .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
                        .onLongPressGesture(minimumDuration: 7, maximumDistance: CGFloat(50), pressing: { pressing in
                            withAnimation(.easeInOut(duration: 1.0)) {
                                self.pressed = pressing
                            }
                            if pressing {
                                self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
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
                                    self.bt.zipdesk.moveToHeight(PresetHeight: self.presetHeight)
                                    print("simultaneous long press activated")
                            }
                            
                        )
                    Text(String(format: "%.1f", presetHeight))
                        .frame(minWidth: 70, idealWidth: 75, maxWidth: 75, minHeight: 70, idealHeight: 75, maxHeight: 75)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                    
                }
            }
            .foregroundColor(ColorManager.preset)
}

    }
}

struct HoldPreset_Previews: PreviewProvider {
    static var previews: some View {
        HoldPreset(presetHeight: .constant(32.0))
    }
}

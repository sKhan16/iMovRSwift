//
//  PresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetButton: View {
    @EnvironmentObject var bt: ZGoBluetoothController
   @Environment(\.colorScheme) var colorScheme
   
    @State private var pressed: Bool = false
    
   @State var name: String
   @State var presetVal: Float
    
    var body: some View {
        Button(action: {
            //self.moveToPreset()
            print("Moved to \(self.presetVal)")
            
        }) {
            VStack {
                Text(String(presetVal))
                
                    .padding(13)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    .padding(6)
                Text(name)
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .frame(width: 80, height: 50)
            .onTapGesture {}
            .onLongPressGesture(minimumDuration: 3.0, maximumDistance: CGFloat(50), pressing: { pressing in
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.pressed = pressing
                }
                if pressing {
                    print("My long pressed starts")
                    //print("     I can initiate any action on start")
                } else {
                    print("My long pressed ends")
                    print("     Desk stops moving")
                }
            }, perform: {
                print("Desk starts moving")
            })
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged({ (touch) in
//                        self.bt.deskWrap?.moveToHeight(PresetHeight: self.presetVal)
//                        print("Preset \(self.presetVal) touchdown")
//                    })
//                    .onEnded({ (touch) in
//                        self.bt.deskWrap?.releaseDesk()
//                        print("Preset \(self.presetVal) released")
//                    })
//            )
        }
    }
    
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    @GestureState var dragState = DragState.inactive
    @State var viewState = CGSize.zero
}



struct PresetButton_Previews: PreviewProvider {
    static var previews: some View {
        PresetButton(name: "Sitting", presetVal: 32.2)
            .environmentObject(ZGoBluetoothController())
    }
}


//You can create a custom view modifier:

extension View {
    func onTouchDownGesture(callback: @escaping () -> Void) -> some View {
        modifier(OnTouchDownGestureModifier(callback: callback))
    }
}

private struct OnTouchDownGestureModifier: ViewModifier {
    @State private var tapped = false
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        self.tapped = true
                        self.callback()
                    }
                }
                .onEnded { _ in
                    self.tapped = false
                })
    }
}

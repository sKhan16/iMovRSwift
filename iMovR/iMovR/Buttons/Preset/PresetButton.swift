//
//  PresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetButton: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    @EnvironmentObject var user: UserObservable
    @Environment(\.colorScheme) var colorScheme
    
    @State private var pressed: Bool = false
    
    //@State var name: String
    //@State var presetVal: Float
    
    //@State var tapped = false
    
    //@Binding var presetName: String
    //@Binding var presetHeight: Float
    //@Binding var isLoaded: Bool
    let index: Int
    @Binding var showAddPreset: Bool
    @Binding var isTouchGo: Bool
    @Binding var isMoving: Bool
    
    //    let customDrag = DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({
    //        print("Moving")
    //    }).onEnded({
    //        print("STOP MOVING")
    //    })
    
    //    let PresetGesture = LongPressGesture(minimumDuration: 3.0, maximumDistance: CGFloat(50))
    //        .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { _ in
    //            if !self.tapped {
    //                self.tapped = true
    //                self.callback()
    //            }
    //        }
    //        .onEnded { _ in
    //            self.tapped = false
    //        })
    
    var body: some View {
        if self.user.testPresets[self.index] > -1 {
            if isTouchGo {
                TouchPreset(zipdeskUI: self.bt.zipdesk, name: "pset \(index)", presetHeight: self.user.testPresets[index], isMoving: self.$isMoving)
            } else {
                HoldPreset(name: "pset \(index)", presetHeight: self.user.testPresets[index])
            }
            //LoadedPreset(name: "pset \(index)", presetHeight: self.user.testPresets[index],
              //           isTouchGo: self.$isTouchGo)
        } else {
            AddPresetButton(index: self.index, showAddPreset: self.$showAddPreset)
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



//struct PresetButton_Previews: PreviewProvider {
//    static var previews: some View {
//        PresetButton(name: "Sitting", presetVal: 32.2)
//            .environmentObject(ZGoBluetoothController())
//    }
//}


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
                        print("moving")
                    }
            }
            .onEnded { _ in
                self.tapped = false
                print("stop moving")
            })
    }
}

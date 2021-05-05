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
    @EnvironmentObject var user: UserDataManager
    @ObservedObject var data: DeviceDataManager
    let index: Int
    @Binding var showAddPreset: Bool
    // @Binding var isTouchGo: Bool   replaced by 'user.tngEnabled'
    @Binding var isMoving: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var pressed: Bool = false
    var geoWidth: CGFloat
    var selectedIndex: Int?
    
    
    var body: some View {
        
        
        if let deskIndex: Int = data.devicePickerIndex {
            
            let currDesk: Desk? = data.savedDevices[deskIndex]
            let height: Float? = currDesk?.presetHeights[self.index]
            
            if height != nil, height! > -1.0 {
                
                let heightBinding = Binding<Float> (
                    get: { height! },
                    set: { _ in } /*Intended for Read-Only*/
                )
                ZStack {
                    if self.data.connectedDeskIndex == self.data.devicePickerIndex {
                    
                        if user.tngEnabled {
                            ZStack {
                                TouchPreset(zipdeskUI: self.bt.zipdesk,
                                            presetHeight: heightBinding,
                                            geoWidth: geoWidth
                                )
                            }
                        }
                        else {
                            HoldPreset(presetHeight: heightBinding, geoWidth: geoWidth)
                        }
                   
                    } else {
                        InactivePreset(zipdeskUI: self.bt.zipdesk,
                                       presetHeight: heightBinding,
                                       geoWidth: geoWidth)
                    }
                    Text(currDesk!.presetNames[self.index])
                        .font(.system(size: 14))
                        .foregroundColor(ColorManager.gray)
                        .offset(y: 58)
                }
                
            }
            else { // desk is connected, unassigned preset
                ZStack {
                    AddPresetButton(geoWidth: geoWidth, index: self.index, showAddPreset: self.$showAddPreset)
                }
                }
            
        }
        else { // desk not connected
            ZStack {
                AddPresetButton(geoWidth: geoWidth, index: self.index, showAddPreset: self.$showAddPreset)
            }
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
//        PresetButton(data: DeviceDataManager(), index: , showAddPreset: , isTouchGo: , isMoving: )
//            .environmentObject(DeviceBluetoothManager(previewMode: true))
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

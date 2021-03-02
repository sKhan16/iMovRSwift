//
//  HomeViewV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeViewV2: View {
    
    @EnvironmentObject var user: UserDataManager
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var zipdeskUI: ZGoZipDeskController
    @ObservedObject var data: DeviceDataManager
    
    @State var showAddPreset: [Bool] = [Bool](repeating: false, count: 6)
    
    @State private var showPresetPopup: Bool = false
    @State private var popupBackgroundBlur: CGFloat = 0
    
    @State private var notMovingTimer: Timer?
    @State private var unpressedUpDownTimer: Timer?
    @State private var suppressStopButton: Bool = false
    
    
    @State private var isPaged: Bool = false

    @State var isMoving: Bool = false
    
    
    var body: some View {
        GeometryReader { geo in
            // ZStack for applying popups to the main view
            ZStack(alignment: .center) {
                VStack {
                    Image("iMovRLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding([.leading,.trailing], 40)
                    Color.white
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .padding([.leading,.trailing], 30)
//                        .frame(width: geo.size.width / 6, height: geo.size.height / 10)
                    
                    DevicePicker (data: self.data)
                    
                    ZStack(alignment: .center) {
                        HeightSliderV2(zipdeskUI: self.zipdeskUI, deviceData: self.data, isPaged: self.$isPaged)
                            .frame(minWidth: 50,maxWidth: 50, maxHeight: .infinity)
                            .padding()
                        
                        HStack {
                            VStack() {
                                HStack() {
                                    Spacer()
                                    Text(String(format: "%.1f", self.zipdeskUI.deskHeight))
                                        .font(.system(size: 55))
                                        .lineLimit(1)
                                        .foregroundColor(Color.white)
                                    Text("in")
                                        .foregroundColor(ColorManager.textColor)
                                        .font(.system(size: 42))
                                        .offset(y: 4)
                                }
                            }
                            .padding(.trailing, 25)
                            
                            HStack {
                                Spacer()
                                VStack {
                                    UpButton (
                                        pressed: self.$suppressStopButton,
                                        unpressedTimer: self.$unpressedUpDownTimer
                                    )
                                        //.padding(.bottom, 5)
                                    DownButton (
                                        pressed: self.$suppressStopButton,
                                        unpressedTimer: self.$unpressedUpDownTimer
                                    )
                                        //.padding(.top, 5)
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    } // end ZStack
                    .frame(maxWidth: .infinity)
                    ZStack {
                        PresetModule (
                            isPaged: self.$isPaged,
                            isMoving: self.$isMoving,
                            showAddPreset: self.$showAddPreset,
                            showPresetPopup: self.$showPresetPopup
                        )
                        if (!suppressStopButton && isMoving && user.tngEnabled) {
                            ColorManager.bgColor //stop button can cover up PresetModule
                                .frame(height: 190)
                        }
                    }
                    .padding(.bottom, 10)
                    .frame(width: geo.size.width, height: 200)
                } // end top-level VStack containing homepage main components
                .blur(radius: popupBackgroundBlur)
                
                
                // Popup for editing saved device properties
                if (showPresetPopup) {
                    PresetEditPopup (
                        show: self.$showPresetPopup
                    )
                        .environmentObject(bt)
                        .onAppear() {
                            self.popupBackgroundBlur = 5
                            withAnimation(.easeIn(duration: 5),{})
                        }
                        .onDisappear() {
                            self.popupBackgroundBlur = 0
                            withAnimation(.easeOut(duration: 5),{})
                        }
                }
                
                
                // Popup for Stop Button
                if (!suppressStopButton && isMoving && user.tngEnabled) {
                    StopGoButton()
                }
                
            } // end top-level ZStack
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.0),{})
            }
            .onChange(of: zipdeskUI.deskHeight, perform: { value in
                self.isMoving = true
                self.notMovingTimer?.invalidate()
                self.notMovingTimer = nil
                print("desk moving")
                self.notMovingTimer = Timer.scheduledTimer (
                    withTimeInterval: 0.5,
                    repeats: false )
                { timer in
                    print("desk stopped")
                    self.isMoving = false
// potential fix for height off by 0.1 annoyance
//self.zipdeskUI.normalizedHeight = /*the height of last used preset; IFF moved by preset and just stopped*/
                }
            })
        }//end GeoReader
    }//end body
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                HomeViewV2 (
                    zipdeskUI: ZGoZipDeskController(),
                    data: DeviceDataManager(test: true)!
                )
                .environmentObject(DeviceBluetoothManager(previewMode: true)!)
                .environmentObject(UserDataManager())
            }
            .previewDevice("iPhone 12")
            
//            ZStack {
//                Image("Background")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .edgesIgnoringSafeArea(.all)
//
//                HomeViewV2 (
//                    zipdeskUI: ZGoZipDeskController(),
//                    data: DeviceDataManager(test: true)!
//                )
//                .environmentObject(DeviceBluetoothManager(previewMode: true)!)
//                .environmentObject(UserDataManager())
//            }
//            .previewDevice("iPhone 6s")
////            .previewDevice("iPhone SE (1st generation)")
            
        }
    }
}

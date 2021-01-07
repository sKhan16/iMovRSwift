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
    @State private var showTNGWarningPopup: Bool = false
    @State private var popupBackgroundBlur: CGFloat = 0
    
    @State private var notMovingTimer: Timer?
    @State private var suppressStopButton: Bool = false
    @State private var isPaged: Bool = false

    @State var isTouchGo: Bool = false
    @State var isMoving: Bool = false
    
    @State private var testHeight: Float = 35.0
    
    var body: some View {
        GeometryReader { geo in
            // ZStack for applying popups to the main view
            ZStack(alignment: .center) {
                VStack {
                    Image("imovrLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width / 6, height: geo.size.height / 10)
                    
                    DevicePicker(deviceData: self.data)
                        .padding([.leading, .trailing])
                    
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
                                        testHeight: self.$testHeight
                                    )
                                        .padding(.bottom, 10)
                                    DownButton (
                                        pressed: self.$suppressStopButton,
                                        testHeight: self.$testHeight
                                    )
                                        .padding(.top, 10)
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    } // end ZStack
                    .frame(maxWidth: .infinity)
                    ZStack {
                        PresetModule(isPaged: self.$isPaged, showAddPreset: self.$showAddPreset, isTouchGo:self.$isTouchGo, showPresetPopup: self.$showPresetPopup, isMoving: self.$isMoving)
                        if (!suppressStopButton && isMoving && isTouchGo) {
                            ColorManager.bgColor //stop button can cover up PresetModule
                                .frame(height: 190)
                        }
                    }
                    .padding(.bottom, 10)
                    .frame(height: 200)
                } // end top-level VStack containing homepage main components
                .blur(radius: popupBackgroundBlur)
                
                
                // Popup for editing saved device properties
                if (showPresetPopup) {
                    PresetEditPopup (
                        show: self.$showPresetPopup,
                        isTouchGo: self.$isTouchGo,
                        showTNGWarningPopup: self.$showTNGWarningPopup
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
                
                
                if showTNGWarningPopup,
                   !self.user.agreedToZipDeskWaiver {
                    TouchNGoPopup (
                        show: self.$showTNGWarningPopup
                        
                    )
                    
                    //Text("Moving your desk via bluetooth could result in injury. iMovR and affiliated are not responsible for any damages that occur. Please press confirm if you agree to these terms")
                }
                
                
                // Popup for Stop Button
                if (!suppressStopButton && isMoving && isTouchGo) {
                    StopGoButton()
                }
                
            } // end top-level ZStack containing main home page components and popup overlays
            .onAppear() {
                withAnimation(.easeInOut(duration: 10),{})
            }
            .onChange(of: zipdeskUI.deskHeight, perform: { value in
                self.isMoving = true
                self.notMovingTimer?.invalidate()
                self.notMovingTimer = nil
                print("HomeView: notMovingTimer start")
                self.notMovingTimer = Timer.scheduledTimer (
                    withTimeInterval: 0.5,
                    repeats: false )
                { timer in
                    print("HomeView: notMovingTimer triggered")
                    self.isMoving = false
                }
            })
        }//end GeoReader
    }//end body
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)

                HomeViewV2(zipdeskUI: ZGoZipDeskController(), data: DeviceDataManager(test: true)!)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 11")
            
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                HomeViewV2(zipdeskUI: ZGoZipDeskController(), data: DeviceDataManager(test: true)!)
                    .environmentObject(DeviceBluetoothManager(previewMode: true)!)
            }
            .previewDevice("iPhone 6s")
        }
    }
}

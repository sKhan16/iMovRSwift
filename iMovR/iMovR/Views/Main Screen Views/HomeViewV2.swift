//
//  HomeViewV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeViewV2: View {
    
    @EnvironmentObject var bt: DeviceBluetoothManager
    @ObservedObject var zipdeskUI: ZGoZipDeskController
    
    @State var showAddPreset: [Bool] = [Bool](repeating: false, count: 6)
    @State private var showPresetPopup: Bool = false
    @State private var popupBackgroundBlur: CGFloat = 0

    @State var isTouchGo: Bool = false
    @State var isMoving: Bool = false
    
    @State private var testHeight: Float = 35.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                VStack {
                    Image("imovrLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width / 6, height: geo.size.height / 10)
                    DevicePicker()
                        .padding([.leading, .trailing])
                    ZStack {
                        HeightSliderV2(zipdeskUI: self.zipdeskUI)
                            .frame(minWidth: 20,maxWidth: 20, maxHeight: .infinity)
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
                                    UpButton(testHeight: self.$testHeight)
                                        .padding(.bottom, 10)
                                    DownButton(testHeight: self.$testHeight)
                                        .padding(.top, 10)
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    PresetModule(isPaged: false, showAddPreset: self.$showAddPreset, isTouchGo:self.$isTouchGo, showPresetPopup: self.$showPresetPopup, isMoving: self.$isMoving)
                        .frame(height: 180)
                        .padding(.bottom, 10)

                } // end vstack with homepage main components
                .blur(radius: popupBackgroundBlur)
            
                // Popup for editing saved device properties
                if (showPresetPopup) {
                    PresetEditPopup(show: $showPresetPopup, isTouchGo: self.$isTouchGo)
                    .onAppear() {
                        self.popupBackgroundBlur = 5
                        withAnimation(.easeIn(duration: 5),{})
                    }
                    .onDisappear() {
                        self.popupBackgroundBlur = 0
                        withAnimation(.easeOut(duration: 5),{})
                    }
                }
            }/*end ZStack*/
            .onAppear() {
            withAnimation(.easeInOut(duration: 10),{})
            }
        }//end GeoReader
    }//end body
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)

                HomeViewV2(zipdeskUI: ZGoZipDeskController())
                    .environmentObject(DeviceBluetoothManager())
            }
            .previewDevice("iPhone 11")
            
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                HomeViewV2(zipdeskUI: ZGoZipDeskController())
                    .environmentObject(DeviceBluetoothManager())
            }
            .previewDevice("iPhone 6s")
        }
    }
}

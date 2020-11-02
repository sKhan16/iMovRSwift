//
//  HomeViewV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeViewV2: View {
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @State var showAddPreset: [Bool] = [Bool](repeating: false, count: 6)
    @State private var showPresetPopup: Bool = false
    @State private var popupBackgroundBlur: CGFloat = 0

    @State var isTouchGo: Bool = false
    
    @State private var testHeight: Float = 35.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                VStack {
                    Image("imovrLogo")
                        .resizable()
                        .frame(width: geo.size.width / 6, height: geo.size.height / 10)
              
                    /* why use ZStack? curious. device picker works in the below VStack
                    Spacer().frame(height: 70)
                    ZStack {
                        HStack {
                            DevicePicker()
                     
                        } //end HStack
                    } //end ZStack
                    */
                    
                        
                        DevicePicker()
        
                        HStack {

                            HStack {
                                Text(String(format: "%.1f", (self.bt.zipdesk?.deskHeight) ?? 0.0))
                                    .font(.system(size: 75))
                                    .padding(.leading)
                                    .foregroundColor(Color.white)
                                Text("in")
                                    .foregroundColor(ColorManager.textColor)
                                    .font(.system(size: 52))
                            }
                            .padding(.trailing)
 
                                    HeightSliderV2().frame(minWidth: 20,maxWidth: 20, maxHeight: .infinity)
                                        .padding(.trailing)
                            
                            // By default slider size is undefined, fills container
                                        //.padding([.top,.bottom], 20)

                            
                            VStack(alignment: .leading) {
                                UpButton(testHeight: self.$testHeight)
                                    .padding(.bottom, 10)
                                DownButton(testHeight: self.$testHeight)
                                    .padding(.top, 10)
                            }
                            .padding()
                        }
                    
                        .frame(maxWidth: .infinity)
                    
                    PresetModule(isPaged: false, showAddPreset: self.$showAddPreset, isTouchGo:self.$isTouchGo, showPresetPopup: self.$showPresetPopup)

                } // end vstack with homepage main components
                }//end 1st level VStack
                .blur(radius: popupBackgroundBlur)
                
                // Popup for editing saved device properties
                if (showPresetPopup) {
                    PresetEditPopup(show: $showPresetPopup,
                                    isTouchGo: self.$isTouchGo)
                        .onAppear() {
                            self.popupBackgroundBlur = 5
                            withAnimation(.easeIn(duration: 5),{})
                        }
                        .onDisappear() {
                            self.popupBackgroundBlur = 0
                            withAnimation(.easeOut(duration: 5),{})
                        }
                }
            }/*end ZStack*/.onAppear() {
            withAnimation(.easeInOut(duration: 10),{})
        }
        }//end GeoReader
        
    }//end body

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                HomeViewV2()
                    .environmentObject(UserObservable())
                    .environmentObject(DeviceBluetoothManager())
            }
            .previewDevice("iPhone 11")
            ZStack {
                ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                HomeViewV2()
                    .environmentObject(UserObservable())
                    .environmentObject(DeviceBluetoothManager())
            }
            .previewDevice("iPhone 6s")
        }
    }
}

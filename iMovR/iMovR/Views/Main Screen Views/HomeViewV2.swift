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
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @State var showAddPreset: [Bool] = [Bool](repeating: false, count: 6)
    @State private var showPresetPopup: Bool = false
    @State private var popupBackgroundBlur: CGFloat = 0

    @State var isTouchGo: Bool = false
    
//    @State var presetName: String = ""
//    @State var presetHeight: Float = 0.0
    
//    @State private var showBTConnect: Bool = false
    @State private var testHeight: Float = 35.0
    @State private var progressValue: Float = 0.7
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                VStack {
                    Image("imovrLogo")
                        .resizable()
                        .frame(width: geo.size.width / 6, height: geo.size.height / 10)
                        //.padding(.top)
                    
                    /* why use ZStack? curious. device picker works in the below VStack
                    Spacer().frame(height: 70)
                    ZStack {
                        HStack {
                            DevicePicker()
                     
                        } //end HStack
                    } //end ZStack
                    */
                    
                    VStack(alignment: .center) {
                        
                        DevicePicker()
                        //BTConnectButton(showBTConnect: self.$showBTConnect)
                            .padding(.bottom, 20)
        
                        HStack {
                            //Height indicator goes here,,
                            //Or build height indicators into the HeightSlider and remove the Spacer()
                            //HStack {
                                Text(String(format: "%.1f", self.bt.currentHeight))
                                    .font(.system(size: 86))
                                    .padding(.leading)
                                    .foregroundColor(Color.white)
                                Text("in")
                                    .foregroundColor(ColorManager.textColor)
                                    .font(.system(size: 64))
                            //}
                            //Spacer()
                            
                            //VStack(alignment: .leading) { // this alignment doesnt seem to change anything
                                //HStack(alignment: .top) {
                                    HeightSliderV2(barProgress: self.$progressValue).frame(minWidth: 20,maxWidth: 20, maxHeight: .infinity)// By default slider size is undefined, fills container
                                        //.padding([.top,.bottom], 20)
                                //}
                            //}
                            
                            VStack(alignment: .leading) {
                                //Spacer()
                                UpButton(testHeight: self.$testHeight)
                                    .padding(.bottom, 10)
                                DownButton(testHeight: self.$testHeight)
                                    .padding(.top, 10)
                                //Spacer()
                            }
                            .padding()
                        }//end HStack
                        //.alignmentGuide(.leading, computeValue: { d in d[.leading] })
                    }//end 2nd level VStack
                    .frame(maxWidth: .infinity)
                    
                    PresetModule(isPaged: false, showAddPreset: self.$showAddPreset, isTouchGo:self.$isTouchGo, showPresetPopup: self.$showPresetPopup)
                        //.padding()
    //                VStack {
    //                    HStack {
    //                        AddPresetButton(showAddPreset: self.$showAddPreset)
    //                    }
    //                }
                    
                    /* dont need touch & go slider/stuff on home page anymore...
                    VStack (alignment: .center) {
                    Text("Touch & Go")
                        Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
                    }
                    
                    VStack {
                        if self.isTouchGo {
                            TouchGoButton(isTouchGo: self.$isTouchGo,
                                presetHeight:
                                self.$presetHeight)
                        } else {
                        HoldButton(presetName: self.$presetName, presetHeight: self.$presetHeight)
                        }
                    }
                    //.padding(.bottom)
                    //Spacer()
                    */
                    
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
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            HomeViewV2()
                .environmentObject(UserObservable())
                .environmentObject(ZGoBluetoothController())
        }
    }
}
